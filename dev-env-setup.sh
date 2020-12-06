#!/bin/bash

printUsage() {
    echo "bash ./dev-environment-setup.sh [-e] [-s]"
    echo -e "\n    where:"
    echo -e "\t-e Exit on failure"
    echo -e "\t-s Step through\n"
}

# Defaults
exitonfail=false
stepwise=false

logfile="./dev-env-setup.log"
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

# params: 
# 1 = status of previous command
# 2 = success message
# 3 = failure message
function check_status() {
    # TODO check if num params not expected

    if [ $1 -eq 0 ] 
    then
        printf "%s \n\n" "$2" | tee -a $logfile
    else 
        printf "=== FAILURE: %s === \n" "$3" | tee -a $logfile
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
}



# Setup keyboard - UK layout
#ref: https://askubuntu.com/questions/356763/setting-up-a-uk-keyboard-layout
echo "Setting keyboard layout to GB..." | tee -a $logfile
setxkbmap -layout gb
check_status $? "Sucessfully set GB keyboard layout." "Could not set GB keyboard layout"


# Update
echo "Running apt-get update... (long)" | tee -a $logfile
sudo apt-get update >> $logfile 2>&1
check_status "apt-get update completed." "Could not apt-get update"

# Upgrade
echo "Running apt-get upgrade... (longer)" | tee -a $logfile
sudo apt-get upgrade -y >> $logfile 2>&1
check_status $? "apt-get upgrade completed." "Could not apt-get upgrade"


# Install packages based on contents of packages-for-install.txt
# File must have LF line endings. 
echo "Installing packages from list..." | tee -a $logfile
xargs sudo apt-get install -y < packages-for-install.txt  >> $logfile 2>&1
check_status $? "Installed ALL packages sucessfully. " "Could not install one or more requested package. See $logfile for details. "


# Install chrome
# Download
echo "Installing chrome..." | tee -a $logfile
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >> $logfile 2>&1
check_status $? "Downloaded chrome sucessfully. " "Could not download chrome. "

# Install
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb  >> $logfile 2>&1
check_status $? "Installed chrome sucessfully. " "Could not install chrome. "

# Set chrome as default
sudo update-alternatives --config x-www-browser << EOF
0
EOF
check_status $? "Set chrome as default browser. " "Could not set default browser. "


# Install VSCode (needs repo dependency)
#ref: https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
echo "Installing vscode..." | tee -a $logfile
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -  >> $logfile 2>&1
check_status $? "Got vscode step 1/3..." "Could not get vscode"

sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"  >> $logfile 2>&1
check_status $? "Got vscode step 2/3..." "Could not get vscode"
sudo apt update  >> $logfile 2>&1
check_status $? "Got vscode step 3/3..." "Could not get vscode"
sudo apt install -y code  >> $logfile 2>&1
check_status $? "Installed vscode. " "Could not install vscode"


# Install VScode extensions
echo "Installing vscode extensions..." | tee -a $logfile
cat vscode-extensions-for-install.txt | while read line
do
    code --install-extension $line  >> $logfile 2>&1
done
echo "Done. " | tee -a $logfile
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Copy in vscode settings
echo "Copying vscode settings..."
mkdir -p ~/.config/Code/User/
check_status $? "Created vscode config directory for user. " "Could not create vscode config dir"
cp vscode-settings.json ~/.config/Code/User/settings.json  >> $logfile 2>&1
check_status $? "Copied vscode settings. " "Could not copy vscode settings"


# Setup Gnome favorites bar
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'org.gnome.Terminal.desktop']"
check_status $? "Set favorites bar icons" "Could not set favorites bar icons"



echo "SETUP COMPLETE. If not run with -e, check output and/or $logfile manually for errors (if you care). " | tee -a $logfile