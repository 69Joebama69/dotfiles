screenshot() {
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  scrot --delay 5 -a $(slop) $HOME/Pictures/Screenshots/$dt
}

main() {
  choice=$( (get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" )

  # If user has not picked anything, exit
  if [[ -z "${choice// }" ]]; then
      exit 1
  fi

  # run the selected command
  case $choice in
    '  Capture Region  Clip')
      crtc
      ;;
    '  Capture Region  File')
      crtf
      ;;
    '  Capture Screen  Clip')
      cstc
      ;;
    '  Capture Screen  File')
      cstf
      ;;
    '  Record Region  File (GIF)')
      rgrtf
      ;;
    '  Record Screen  File (GIF)')
      rgstf
      ;;
    '  Record Region  File (MP4)')
      rvrtf
      ;;
    '  Record Screen  File (MP4)')
      rvstf
      ;;
  esac

  # done
  set -e
}

main $1 &

exit 0

