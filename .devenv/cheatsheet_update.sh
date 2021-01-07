#!/bin/bash

# Get all bings from installed i3 config file
IFS= #stop field splitting (removes newlines during $() command substitution)
BINDS=$( sed -ne '/^bind/{
    s/--no-startup-id //;
    s/--whole-window //;
    s/--release //;
    s/$mod+/Win+/;
    s/exec //g;
    s/bindsym //p}' <<< cat ~/.config/i3/config ) 
echo $BINDS > ~/.devenv/binds.txt

# Put each keybind line into an array
arr=()
while IFS= read -r line; do
  arr+=("$line")
done < ~/.devenv/binds.txt

# Iterate through each binding and process for display
echo "" > ~/.devenv/binds.txt # empty file for re-use
for i in "${arr[@]}"
do
    #echo "\nProcessing line: $i"
    IFS=' ' read -r keypress remainder <<< "$i" #split kepress out of line
    IFS='#' read -r cmd comment <<< "$remainder" #split command, comment out of line

    echo "$keypress# $comment# $cmd" >> ~/.devenv/binds.txt
done

# Save to file
column -et -c Keypress,Function,Command -s "#" ~/.devenv/binds.txt > ~/.binds.txt