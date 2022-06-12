title=`xprop | grep "WM_NAME(STRING)" # | cut -d "=" -f2 # | sed 's/ *$//g' | sed 's/^ *//g'`

echo $title

className=`xprop | grep "WM_CLASS" | cut -d "=" -f2 | cut -d "," -f1 | sed 's/ *$//g' | sed 's/^ *//g'` 
command="for_window [class=$className] flaoting enable"

# echo $command >> /home/$USER/.config/i3/config
