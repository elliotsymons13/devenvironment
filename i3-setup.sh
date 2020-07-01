#!/bin/bash


printUsage() {
    echo "bash ./i3-setup.sh [-e] [-s]"
    echo -e "\n    where:"
    echo -e "\t-e Exit on failure"
    echo -e "\t-s Step through\n"
}

# Defaults
exitonfail=false
stepwise=false

logfile="./i3-setup.log"
touch $logfile
>$logfile # empty log file

# Check arguments
while getopts "esh:" thisinput; do
    case "$thisinput" in
        h)
            # Help Arg
            printUsage
            exit
            ;;
        e)
            echo "Will exit on first failure." | tee -a $logfile
            exitonfail=true
            ;;
        s)
            echo "Will execute each command when instructed. " | tee -a $logfile
            stepwise=true
            ;;
        *)
            # Any other Args
            printUsage
            exit
            ;;
    esac
done

#somewhat from ref: https://github.com/addy-dclxvi/i3-starterpack heavily adapted

echo "Running apt-get update... (long unless recently run)" | tee -a $logfile
sudo apt-get update  >> $logfile
if [ $? -eq 0 ] 
then
    printf "atp-get update completed.  \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to apt-get update === \n" | tee -a $logfile
    if [ "$exitonfail" = true ]; 
    then
        echo "Exiting... see log for details" | tee -a $logfile
        exit 1
    fi
fi
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Install i3
echo "Installing i3... " | tee -a $logfile
sudo apt-get install -y i3 >> $logfile
if [ $? -eq 0 ] 
then
    printf "Installed i3 \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to install i3 === \n" | tee -a $logfile
    if [ "$exitonfail" = true ]; 
    then
        echo "Exiting... see log for details" | tee -a $logfile
        exit 1
    fi
fi
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Install additional packages to impove experience
#sudo apt-get install -y compton hsetroot
# TODO configure these

# Copy in i3 config file
echo "Copying i3 config files... " | tee -a $logfile
mkdir -p ~/.config/i3/
cp i3-config.txt ~/.config/i3/config >> $logfile
if [ $? -eq 0 ] 
then
    printf "Installed i3 config files.  \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to install i3 config === \n" | tee -a $logfile
    if [ "$exitonfail" = true ]; 
    then
        echo "Exiting... see log for details" | tee -a $logfile
        exit 1
    fi
fi
# TODO more configs here, EG i3status, etc.
echo "Finished installing all configs. " | tee -a $logfile
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Fix scaling - make Xresources file
#ref: https://www.reddit.com/r/i3wm/comments/6kxq83/i3wm_scaling_is_correct_but_programs_are_not_hidpi/
# TODO make value conditional based on screen size? Currently good only for 1080p
touch ~/.Xresources
echo "Xft.dpi: 96" > ~/.Xresources
xrdb ~/.Xresources


# reboot required to get to i3
echo "Need to reboot to finalise installation of i3..."  | tee -a $logfile
read -rsn1 -p"Press any key to continue. Will reboot, then you can select i3 at login screen. ";echo
echo "Rebooting..."  | tee -a $logfile
reboot && exit 0