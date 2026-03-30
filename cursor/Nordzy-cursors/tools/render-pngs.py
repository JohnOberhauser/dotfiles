#!/usr/bin/env python3
#
# SVGSlice - resvg edition
#
# Originally by Lee Braiden of Digital Unleashed (GNU GPL v2).
# Rewritten to use resvg + Pillow for dramatically faster rendering.
#
# Instead of spawning Inkscape once per slice per size, this:
#   1. Parses the SVG to find slice rectangles in the "slices" layer
#   2. Hides the slices layer in a temp copy
#   3. Renders the full SVG once per target size via resvg
#   4. Crops each slice region from the rendered image using Pillow
#
# Dependencies: resvg (pacman -S resvg), Pillow (pip install Pillow)

import os
import sys
import shutil
import tempfile
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from optparse import OptionParser
from xml.sax import make_parser, SAXParseException, handler
from xml.sax.handler import feature_namespaces
from xml.etree import ElementTree as ET
from PIL import Image

USAGE_MSG = """You need to add a layer called "slices", and draw rectangles on it to represent
the areas that should be saved as slices. It helps when drawing these rectangles
if you make them translucent.

If you name these slices using the "id" field of Inkscape's built-in XML editor,
that name will be reflected in the slice filenames.

Please remember to HIDE the slices layer before exporting, so that the rectangles
themselves are not drawn in the final image slices."""

TARGET_SIZES = [24, 32, 48, 64, 96]

optParser = OptionParser()
optParser.add_option('-d', '--debug', action='store_true', dest='debug',
                     help='Enable extra debugging info.')
optParser.add_option('-t', '--test', action='store_true', dest='testing',
                     help='Test mode: leave temporary files for examination.')
optParser.add_option('-p', '--sliceprefix', action='store', dest='sliceprefix',
                     help='Specifies the prefix to use for individual slice filenames.')
optParser.add_option('-j', '--jobs', action='store', dest='jobs', type='int', default=0,
                     help='Number of parallel jobs (0 = auto)')

options = None


def dbg(msg):
	if options and options.debug:
		sys.stderr.write(msg + '\n')


def fatal_error(msg):
	sys.stderr.write(msg + '\n')
	sys.exit(20)


def parse_coordinate(val):
	"""Strips units from a coordinate value and returns a float."""
	if val is None:
		return 0.0
	val = val.strip()
	for suffix in ('px', 'pt', 'cm', 'mm', 'in', '%'):
		if val.endswith(suffix):
			return float(val[:-len(suffix)])
	try:
		return float(val)
	except ValueError:
		fatal_error(f"Coordinate value '{val}' has unrecognised units.")


class SVGRect:
	"""A rectangular slice region within the SVG."""
	def __init__(self, x, y, width, height, name):
		self.x = x
		self.y = y
		self.width = width
		self.height = height
		self.name = name

	def __repr__(self):
		return f"SVGRect({self.name}: {self.x},{self.y} {self.width}x{self.height})"


def parse_translate(transform_str):
	"""Extract (tx, ty) from a transform attribute containing translate()."""
	if not transform_str:
		return 0.0, 0.0
	import re
	m = re.search(r'translate\(\s*([^,\s]+)\s*[,\s]\s*([^)]+)\)', transform_str)
	if m:
		return float(m.group(1)), float(m.group(2))
	# translate(x) with no y
	m = re.search(r'translate\(\s*([^)]+)\)', transform_str)
	if m:
		return float(m.group(1)), 0.0
	return 0.0, 0.0


def find_slices(svg_path):
	"""Parse the SVG and extract slice rectangles from the 'slices' layer."""
	ns = {
		'svg': 'http://www.w3.org/2000/svg',
		'inkscape': 'http://www.inkscape.org/namespaces/inkscape',
	}

	tree = ET.parse(svg_path)
	root = tree.getroot()

	svg_width = parse_coordinate(root.get('width'))
	svg_height = parse_coordinate(root.get('height'))

	# Check viewBox as fallback for dimensions
	viewbox = root.get('viewBox')
	if viewbox and (svg_width == 0 or svg_height == 0):
		parts = viewbox.split()
		if len(parts) == 4:
			svg_width = float(parts[2])
			svg_height = float(parts[3])

	dbg(f"SVG dimensions: {svg_width} x {svg_height}")

	rects = []

	def search_group(elem, in_slices=False, offset_x=0.0, offset_y=0.0):
		for child in elem:
			tag = child.tag.split('}')[-1] if '}' in child.tag else child.tag

			if tag == 'g':
				groupmode = child.get(f'{{{ns["inkscape"]}}}groupmode', '')
				label = child.get(f'{{{ns["inkscape"]}}}label', '')
				is_slices = (groupmode == 'layer' and label == 'slices')

				# Accumulate this group's translate transform
				tx, ty = parse_translate(child.get('transform', ''))
				new_ox = offset_x + tx
				new_oy = offset_y + ty

				search_group(child, in_slices or is_slices, new_ox, new_oy)

			elif tag == 'rect' and in_slices:
				# Apply the rect's own transform too
				tx, ty = parse_translate(child.get('transform', ''))
				x = parse_coordinate(child.get('x', '0')) + offset_x + tx
				y = parse_coordinate(child.get('y', '0')) + offset_y + ty
				w = parse_coordinate(child.get('width', '0'))
				h = parse_coordinate(child.get('height', '0'))
				name = child.get('id', 'unnamed')
				rect = SVGRect(x, y, w, h, name)
				rects.append(rect)
				dbg(f"  Found slice: {rect}")

	search_group(root)
	return rects, svg_width, svg_height


def hide_slices_layer(svg_path, output_path):
	"""Create a copy of the SVG with the slices layer hidden."""
	ns = {
		'inkscape': 'http://www.inkscape.org/namespaces/inkscape',
	}

	# Register all namespaces so ET doesn't mangle them
	namespaces = {}
	for event, (prefix, uri) in ET.iterparse(svg_path, events=['start-ns']):
		if prefix:
			namespaces[prefix] = uri
	for prefix, uri in namespaces.items():
		ET.register_namespace(prefix, uri)

	tree = ET.parse(svg_path)
	root = tree.getroot()

	def hide_in(elem):
		for child in elem:
			tag = child.tag.split('}')[-1] if '}' in child.tag else child.tag
			if tag == 'g':
				groupmode = child.get(f'{{{ns["inkscape"]}}}groupmode', '')
				label = child.get(f'{{{ns["inkscape"]}}}label', '')
				if groupmode == 'layer' and label == 'slices':
					child.set('style', 'display:none')
					dbg("  Hidden slices layer")
				else:
					hide_in(child)

	hide_in(root)
	tree.write(output_path, xml_declaration=True, encoding='unicode')


def render_full_svg(svg_path, size, svg_width, svg_height, output_png):
	"""Render the full SVG at a scale that maps the SVG's larger dimension to `size`."""
	# We need to figure out what pixel dimensions to render at so that
	# a slice that is, say, 24x24 SVG units ends up as `size` x `size` pixels.
	# The scale factor is: size / slice_dimension.
	# But slices can vary in dimension, so instead we render the full SVG
	# proportionally and crop. We scale based on SVG document units -> pixels.
	#
	# For cursor SVGs, typically each slice is the same size as the viewBox,
	# or the viewBox is a grid. We render at a scale where 1 SVG unit = size/max(slice) pixels.
	# Actually, simplest correct approach: render at a high enough resolution
	# that we can crop. We'll compute per-slice later.
	#
	# For the common case (Nordzy cursors), each SVG has one cursor at the document size.
	# We render the full SVG at each target pixel size.

	cmd = ['resvg', svg_path, output_png, '-w', str(size), '-h', str(size)]
	dbg(f"  Running: {' '.join(cmd)}")
	result = subprocess.run(cmd, capture_output=True, text=True)
	if result.returncode != 0:
		sys.stderr.write(f"resvg error: {result.stderr}\n")
		return False
	return True


def render_and_crop(svg_path, rects, svg_width, svg_height, sliceprefix, jobs):
	"""Render the SVG and crop out each slice at each target size."""

	# For cursor themes, slices are typically the full document size.
	# For general SVGs with multiple slices, we need to render at a resolution
	# high enough to crop individual slices at each target size.
	#
	# Strategy: render the full SVG once at a scale that gives us enough pixels,
	# then crop each slice and resize to target.

	with tempfile.TemporaryDirectory() as tmpdir:
		# Determine the scale: we want the largest target size to have enough
		# pixels. Render at a scale where 1 SVG unit = max_target / min_slice_dim pixels.
		if not rects:
			return

		min_slice_dim = min(min(r.width, r.height) for r in rects if r.width > 0 and r.height > 0)
		if min_slice_dim <= 0:
			min_slice_dim = 1

		max_target = max(TARGET_SIZES)
		scale = max_target / min_slice_dim

		render_w = max(1, int(svg_width * scale))
		render_h = max(1, int(svg_height * scale))

		full_png = os.path.join(tmpdir, 'full.png')
		cmd = ['resvg', svg_path, full_png, '-w', str(render_w), '-h', str(render_h)]
		dbg(f"Rendering full SVG at {render_w}x{render_h}")
		result = subprocess.run(cmd, capture_output=True, text=True)
		if result.returncode != 0:
			fatal_error(f"resvg failed: {result.stderr}")

		full_img = Image.open(full_png)
		full_img.load()  # Force full decode — Image.open() is lazy and not thread-safe
		actual_w, actual_h = full_img.size

		# Scale factors from SVG units to rendered pixels
		sx = actual_w / svg_width if svg_width > 0 else 1
		sy = actual_h / svg_height if svg_height > 0 else 1

		def process_rect(rect):
			# Crop region in pixel coordinates
			left = int(rect.x * sx)
			top = int(rect.y * sy)
			right = int((rect.x + rect.width) * sx)
			bottom = int((rect.y + rect.height) * sy)

			# Clamp to image bounds
			left = max(0, left)
			top = max(0, top)
			right = min(actual_w, right)
			bottom = min(actual_h, bottom)

			if right <= left or bottom <= top:
				sys.stderr.write(f"Warning: slice '{rect.name}' has zero area, skipping.\n")
				return

			cropped = full_img.crop((left, top, right, bottom))

			for size in TARGET_SIZES:
				out_dir = f'pngs/{size}'
				out_path = os.path.join(out_dir, sliceprefix + rect.name + '.png')
				resized = cropped.resize((size, size), Image.LANCZOS)
				resized.save(out_path, 'PNG')
				dbg(f"  Saved {out_path}")

		if jobs == 1 or len(rects) == 1:
			for rect in rects:
				process_rect(rect)
		else:
			max_workers = jobs if jobs > 0 else min(len(rects), os.cpu_count() or 4)
			with ThreadPoolExecutor(max_workers=max_workers) as pool:
				futures = {pool.submit(process_rect, r): r for r in rects}
				for f in as_completed(futures):
					exc = f.exception()
					if exc:
						sys.stderr.write(f"Error processing {futures[f].name}: {exc}\n")


def main():
	global options

	(options, args) = optParser.parse_args()

	if len(args) != 1:
		fatal_error("Call me with the SVG file as a parameter.\n")

	original = args[0]
	if not os.path.exists(original):
		fatal_error(f"File not found: {original}\n")

	sliceprefix = options.sliceprefix or ''
	jobs = options.jobs if options.jobs else 0

	# Ensure output directories exist
	for size in TARGET_SIZES:
		os.makedirs(f'pngs/{size}', exist_ok=True)

	# Parse slices from the SVG
	dbg(f"Parsing {original} for slices...")
	rects, svg_width, svg_height = find_slices(original)

	if not rects:
		fatal_error("No slices found in the SVG file.\n\n" + USAGE_MSG)

	dbg(f"Found {len(rects)} slices.")

	# Create a temp SVG with the slices layer hidden
	tmp_svg = original + '.tmp.svg'
	try:
		hide_slices_layer(original, tmp_svg)

		# Render and crop
		render_and_crop(tmp_svg, rects, svg_width, svg_height, sliceprefix, jobs)
	finally:
		if not options.testing and os.path.exists(tmp_svg):
			os.unlink(tmp_svg)

	dbg("Slicing complete.")


if __name__ == '__main__':
	main()