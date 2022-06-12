notify-send "Screenshot" "Select a region to capture"
ffcast -q $(slop -n -f '-g %g ') png /tmp/screenshot_clip.png
xclip -selection clipboard -t image/png /tmp/screenshot_clip.png
rm /tmp/screenshot_clip.png
notify-send "Screenshot" "Region copied to Clipboard"
