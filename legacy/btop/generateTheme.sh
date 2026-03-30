#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 --bg <background> --fg <foreground> --dim <dim_color> --primary <primary_color> --output <output_file>"
  exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --bg)
      bg="$2"
      shift 2
      ;;
    --fg)
      fg="$2"
      shift 2
      ;;
    --dim)
      dim="$2"
      shift 2
      ;;
    --primary)
      primary="$2"
      shift 2
      ;;
    --output)
      output="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      usage
      ;;
  esac
done

# Check if all required parameters are provided
if [[ -z $bg || -z $fg || -z $dim || -z $primary || -z $output ]]; then
  echo "Error: Missing required parameters."
  usage
  exit 1
fi

mkdir -p $(dirname $output)

# Template content
template="#================= Main Colors ==================
theme[main_bg]=\"#${bg}\"
theme[main_fg]=\"#${fg}\"
theme[title]=\"#${fg}\"
theme[hi_fg]=\"#${primary}\"
theme[selected_bg]=\"#${primary}\"
theme[selected_fg]=\"#${fg}\"
theme[inactive_fg]=\"#${dim}\"
theme[proc_misc]=\"#${primary}\"

#================= Box Outlines ==================
theme[cpu_box]=\"#${dim}\"
theme[mem_box]=\"#${dim}\"
theme[net_box]=\"#${dim}\"
theme[proc_box]=\"#${dim}\"
theme[div_line]=\"#${dim}\"

#================= Meters ==================
# Mem/Disk used meter
theme[used_start]=\"#${fg}\"
theme[used_mid]=\"#${primary}\"
theme[used_end]=\"#${primary}\"

# Mem/Disk available meter
theme[available_start]=\"#${fg}\"
theme[available_mid]=\"#${primary}\"
theme[available_end]=\"#${primary}\"

# Mem/Disk cached meter
theme[cached_start]=\"#${fg}\"
theme[cached_mid]=\"#${primary}\"
theme[cached_end]=\"#${primary}\"

# Mem/Disk free meter
theme[free_start]=\"#${fg}\"
theme[free_mid]=\"#${primary}\"
theme[free_end]=\"#${primary}\"

#================== Graphs ==================
# Temperature graph colors
theme[temp_start]=\"#${fg}\"
theme[temp_mid]=\"#${primary}\"
theme[temp_end]=\"#${primary}\"

# CPU graph colors
theme[cpu_start]=\"#${primary}\"
theme[cpu_mid]=\"#${primary}\"
theme[cpu_end]=\"#${fg}\"

# Download graph colors
theme[download_start]=\"#${fg}\"
theme[download_mid]=\"#${primary}\"
theme[download_end]=\"#${primary}\"

# Upload graph colors
theme[upload_start]=\"#${fg}\"
theme[upload_mid]=\"#${primary}\"
theme[upload_end]=\"#${primary}\""

# Output the replaced content to the new file
echo "$template" > "${output}"

# Confirm output
echo "Theme file '${name}.theme' has been created."
