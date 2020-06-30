#!/bin/bash/

#somewhat from ref: https://github.com/addy-dclxvi/i3-starterpack

sudo apt-get update

# Install i3
sudo apt-get install -y i3

# Install additional packages to impove experience
sudo apt-get install -y compton hsetroot
# TODO configure these

# Copy in config file
cp i3-config.txt ~/.config/i3/config
# TODO check errors

# Fix scaling - make Xresources file
#ref: https://www.reddit.com/r/i3wm/comments/6kxq83/i3wm_scaling_is_correct_but_programs_are_not_hidpi/
# TODO make value conditional based on screen size? Currently good only for 1080p
touch ~/.Xresources
echo "Xft.dpi: 96" > ~/.Xresources
xrdb ~/.Xresources