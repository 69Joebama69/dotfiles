#!/usr/bin/env bash

## rofi-screenshot
## Author: ceuk @ github
## Licence: WTFPL
## Usage: 
##    show the menu with rofi-screenshot
##    stop recording with rofi-screenshot -s

# Screenshot directory
screenshot_directory="$HOME/Pictures/Screenshots"

rofi() {
  rofi -dmenu -i -fuzzy -p "Screenshot" -theme $HOME/.config/rofi/launchers/colorful/style_7.rasi
}

countdown() {
  notify-send "Screenshot" "Recording in 3 seconds" -t 1000
  sleep 1
  notify-send "Screenshot" "Recording in 2 seconds" -t 1000
  sleep 1
  notify-send "Screenshot" "Recording in 1 seconds" -t 1000
  sleep 1
}

# screenshot region clip
crtc() {
  notify-send "Screenshot" "Select a region to capture"
  slop=$(slop -f "%g") || exit 1
  read -r G < <(echo $slop)
  import -window root -crop $G /tmp/screenshot_clip.png
  xclip -selection clipboard -t image/png /tmp/screenshot_clip.png
  rm /tmp/screenshot_clip.png
  notify-send "Screenshot" "Region copied to Clipboard"
}

# screenshot region file
crtf() {
  notify-send "Screenshot" "Select a region to capture"
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  slop=$(slop -f "%g") || exit 1
  read -r G < <(echo $slop)
  import -window root -crop $G "$screenshot_directory/$dt.png"
  notify-send "Screenshot" "Region saved to $screenshot_directory/$dt.png"
}

# record region file
rvrtf() {
  notify-send "Screenshot" "Select a region to record"
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  slop=$(slop -f "%x %y %w %h %g %i") || exit 1
  read -r X Y W H G ID < <(echo $slop)
  ffmpeg -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y -f alsa -i pulse "$screenshot_directory/$dt.mp4"
  notify-send "Screenshot" "Recording saved to $screenshot_directory/$dt.mp4"
}

get_options() {
  echo "  Capture Region  Clip"
  echo "  Capture Region  File"
  echo "  Record Region  File (MP4)"
}

check_deps() {
  if ! hash $1 2>/dev/null; then
    echo "Error: This script requires $1"
    exit 1
  fi
}

main() {
  # check dependencies
  check_deps slop
  check_deps ffcast
  check_deps ffmpeg
  check_deps xclip
  check_deps rofi

  echo "a"

  if [[ $1 == '--help' ]] || [[ $1 = '-h' ]]
  then
    echo ### rofi-screenshot
    echo USAGE: rofi-screenshot [OPTION]
    echo \(no option\)
    echo "    show the screenshot menu"
    echo -s, --stop
    echo "    stop recording"
    echo -h, --help
    echo "    this screen"
    exit 1
  fi

  echo "b"

  if [[ $1 = '--stop' ]] || [[ $1 = '-s' ]]
  then
    pkill -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*'
    exit 1
  fi
  
  echo "c"

  # Get choice from rofi
  (get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" 
  choice=$((get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" -theme $HOME/.config/rofi/launchers/colorful/style_7.rasi)

  echo "d"

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
    '  Record Region  File (MP4)')
      rvrtf
      ;;
  esac

  # done
  set -e
}

main $1 &

exit 0
