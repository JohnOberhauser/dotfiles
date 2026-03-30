SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/Nordzy-cursors/tools/custom_theme.sh" \
--name "systemCursor" \
--fill "{{colors.on_surface.default.hex}}" \
--border "{{colors.surface.default.hex}}" \
--accent "{{colors.primary.default.hex}}"  \
--purple "{{colors.secondary.default.hex}}" \
--green "{{colors.tertiary.default.hex}}" \
--red "{{base16.base08.default.hex}}" \
--orange "{{colors.outline.default.hex}}"
