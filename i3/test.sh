get_options() {
  echo "  Capture Region  Clip"
  echo "  Capture Region  File"
  echo "  Record Region  File (MP4)"
}

(get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" -theme $HOME/.config/rofi/launchers/colorful/style_7.rasi
