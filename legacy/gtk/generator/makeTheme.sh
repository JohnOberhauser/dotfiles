#! /usr/bin/env bash

set -Eeo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SRC_DIR="${REPO_DIR}/src"
DEST_DIR="$REPO_DIR/../themes"

theme=
bg=
fg=
primary=
error=
warning=
success=

SASSC_OPT="-M -t expanded"

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -t, --theme VARIANT     Name the theme

  --bg Hex-Color (no #), e.g. FF00FF

  --fg  Hex-Color (no #)

  --primary  Hex-Color (no #)

  --error  Hex-Color (no #)

  --warning  Hex-Color (no #)

  --success  Hex-Color (no #)

  -h, --help              Show help
EOF
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -t|--theme)
      theme="${2}"
      shift 2
      ;;
    --bg)
      bg="${2}"
      shift 2
      ;;
    --fg)
      fg="${2}"
      shift 2
      ;;
    --primary)
      primary="${2}"
      shift 2
      ;;
    --error)
      error="${2}"
      shift 2
      ;;
    --warning)
      warning="${2}"
      shift 2
      ;;
    --success)
      success="${2}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ -z $bg || -z $fg || -z $primary || -z $error || -z $warning || -z $success || -z $theme ]]; then
  echo "Error: Missing required parameters."
  usage
  exit 1
fi

install() {
  local name="${1}"

  [[ "${color}" == '-Light' ]] && local ELSE_LIGHT="${color}"
  [[ "${color}" == '-Dark' ]] && local ELSE_DARK="${color}"

  local THEME_DIR="$HOME/workspace/Varda-Theme/themes/$name/gtk"

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"

  echo "Installing '${THEME_DIR}'..."

  theme_color

  mkdir -p                                                                                   "${THEME_DIR}"

  echo "[Desktop Entry]" >>                                                                  "${THEME_DIR}/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                                           "${THEME_DIR}/index.theme"
  echo "Name=SystemTheme" >>                                                                 "${THEME_DIR}/index.theme"
  echo "Comment=An Flat Gtk+ theme based on Elegant Design" >>                               "${THEME_DIR}/index.theme"
  echo "Encoding=UTF-8" >>                                                                   "${THEME_DIR}/index.theme"
  echo "" >>                                                                                 "${THEME_DIR}/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                              "${THEME_DIR}/index.theme"
  echo "GtkTheme=SystemTheme" >>                                                             "${THEME_DIR}/index.theme"
  echo "MetacityTheme=SystemTheme" >>                                                        "${THEME_DIR}/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                                        "${THEME_DIR}/index.theme"

  mkdir -p                                                                                   "${THEME_DIR}/gtk-3.0"
  cp -r "${SRC_DIR}/assets/gtk/assets"                                                       "${THEME_DIR}/gtk-3.0/assets"
  cp -r "${SRC_DIR}/assets/gtk/scalable"                                                     "${THEME_DIR}/gtk-3.0/assets"
  cp -r "${SRC_DIR}/assets/gtk/thumbnail${ELSE_DARK:-}.png"                                  "${THEME_DIR}/gtk-3.0/thumbnail.png"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-3.0/gtk${color}.scss"                                "${THEME_DIR}/gtk-3.0/gtk.css"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-3.0/gtk-Dark.scss"                                   "${THEME_DIR}/gtk-3.0/gtk-dark.css"

  mkdir -p                                                                                   "${THEME_DIR}/gtk-4.0"
  cp -r "${SRC_DIR}/assets/gtk/assets"                                                       "${THEME_DIR}/gtk-4.0/assets"
  cp -r "${SRC_DIR}/assets/gtk/scalable"                                                     "${THEME_DIR}/gtk-4.0/assets"
  cp -r "${SRC_DIR}/assets/gtk/thumbnail${ELSE_DARK:-}.png"                                  "${THEME_DIR}/gtk-4.0/thumbnail.png"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-4.0/gtk${color}.scss"                                "${THEME_DIR}/gtk-4.0/gtk.css"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-4.0/gtk-Dark.scss"                                   "${THEME_DIR}/gtk-4.0/gtk-dark.css"
}

sass_temp() {
  cp -rf ${SRC_DIR}/sass/_tweaks.scss ${SRC_DIR}/sass/_tweaks-temp.scss
}

theme_color() {
  sed -i "/\$theme:/s/default/${theme}/" ${SRC_DIR}/sass/_tweaks-temp.scss

  sed -i "/\$bg:/s/000000/${bg}/" ${SRC_DIR}/sass/_tweaks-temp.scss
  sed -i "/\$fg:/s/000000/${fg}/" ${SRC_DIR}/sass/_tweaks-temp.scss
  sed -i "/\$primary:/s/000000/${primary}/" ${SRC_DIR}/sass/_tweaks-temp.scss
  sed -i "/\$error:/s/000000/${error}/" ${SRC_DIR}/sass/_tweaks-temp.scss
  sed -i "/\$warning:/s/000000/${warning}/" ${SRC_DIR}/sass/_tweaks-temp.scss
  sed -i "/\$success:/s/000000/${success}/" ${SRC_DIR}/sass/_tweaks-temp.scss
}

install_theme() {
  cp -rf ${SRC_DIR}/sass/_tweaks.scss ${SRC_DIR}/sass/_tweaks-temp.scss
  install "$theme"
}

sass_temp && install_theme

echo
echo Done.
