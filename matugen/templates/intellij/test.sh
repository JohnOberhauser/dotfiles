#!/bin/bash
set -uo pipefail

FONT_FAMILY="Monaspace Neon NF"
FONT_SIZE="16"
FONT_SIZE_2D="16.0"
USE_LIGATURES="true"
CHARACTER_VARIANTS=("ss01" "ss02" "ss03" "ss04" "ss05" "ss06" "ss07" "ss08" "ss09" "ss10")
UI_FONT_FAMILY="Monaspace Neon NF"
UI_FONT_SIZE="12.0"

NEW_CONTENT='<application>
  <component name="DefaultFont">
    <option name="VERSION" value="1" />
    <option name="FONT_SIZE" value="'"$FONT_SIZE"'" />
    <option name="FONT_SIZE_2D" value="'"$FONT_SIZE_2D"'" />
    <option name="FONT_FAMILY" value="'"$FONT_FAMILY"'" />
    <option name="USE_LIGATURES" value="'"$USE_LIGATURES"'" />
    <option name="CHARACTER_VARIANTS">
      <set>'

for variant in "${CHARACTER_VARIANTS[@]}"; do
    NEW_CONTENT+="
        <option value=\"$variant\" />"
done

NEW_CONTENT+='
      </set>
    </option>
  </component>
</application>'

found_editor=0
found_other=0

update_font_file() {
    local file="$1"
    echo "$NEW_CONTENT" > "$file"
    echo "Updated: $file"
    ((found_editor++))
}

update_other_file() {
    local file="$1"
    sed -i \
        -e "s|<option name=\"fontFace\" value=\".*\" />|<option name=\"fontFace\" value=\"$UI_FONT_FAMILY\" />|" \
        -e "s|<option name=\"fontSize\" value=\".*\" />|<option name=\"fontSize\" value=\"$UI_FONT_SIZE\" />|" \
        "$file"
    echo "Updated: $file"
    ((found_other++))
}

for options_dir in ~/.config/JetBrains/*/options ~/.config/Google/*/options; do
    editor_file="$options_dir/editor-font.xml"
    other_file="$options_dir/other.xml"

    [[ -f "$editor_file" ]] && update_font_file "$editor_file"
    [[ -f "$other_file" ]] && update_other_file "$other_file"
done

echo ""
[[ $found_editor -eq 0 ]] && echo "No editor-font.xml files found." || echo "Done. Updated $found_editor editor-font.xml file(s)."
[[ $found_other -eq 0 ]] && echo "No other.xml files found." || echo "Done. Updated $found_other other.xml file(s)."