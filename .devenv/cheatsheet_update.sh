#!/bin/bash

# Get all bings from installed i3 config file
IFS= #stop field splitting (removes newlines during $() command substitution)
BINDS=$( sed -ne '/^bind/{
    s/--no-startup-id //;
    s/--whole-window //;
    s/--release //;
    s/$mod+/Win+/;
    s/exec //g;
    s/bindsym //p};
    s/^#/#/p' <<< cat ~/.config/i3/config ) 
echo $BINDS > ~/.devenv/binds.txt #temp store

# Put each keybind line into an array
arr=()
while IFS= read -r line; do
  arr+=("$line")
done < ~/.devenv/binds.txt

# Iterate through each binding and process for display
echo "" > ~/.devenv/binds.txt # empty file for re-use
line_above=""
for line in "${arr[@]}"
do
    echo -e "\nProcessing line: $line"
    # if first char of line is not #, then process command 
    # (will begin bindsym by process of elimination from sed results above)
    if [[ ! $line =~ ^\# ]] ; then
      echo "processing bind.."
      echo "line_above: $line_above"
      IFS=' ' read -r keypress cmd <<< "$line" # split kepress out of line
      echo "key: $keypress"
      echo "cmd: $cmd"
      comment=$( echo $line_above | sed 's/# //;s/#//g' )
      echo "com: $comment"
      echo "$keypress# $comment# $cmd" | tee -a ~/.devenv/binds.txt
    else
      # else just record and move on
      line_above=$line
      echo "Skipping as comment... $line_above"
    fi
done

# Save to file
column -et -c Keypress,Function,Command -s "#" ~/.devenv/binds.txt > ~/.binds.txt