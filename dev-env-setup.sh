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


# Setup keyboard - UK layout
#ref: https://askubuntu.com/questions/356763/setting-up-a-uk-keyboard-layout
setxkbmap -layout gb
if [ $? -eq 0 ] 
then
    printf "Sucessfully set GB keybaord layout.  \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to set GB keybaord layout === \n" | tee -a $logfile
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

# Update
echo "Running apt-get update... (long)" | tee -a $logfile
sudo apt-get update >> $logfile
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
echo "Running apt-get upgrade... (longer)" | tee -a $logfile
sudo apt-get upgrade -y >> $logfile
if [ $? -eq 0 ] 
then
    printf "atp-get upgrade completed.  \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to apt-get upgrade === \n" | tee -a $logfile
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

# Install packages
# File must have LF line endings. 
echo "Installing packages from list..." | tee -a $logfile
xargs sudo apt-get install -y < packages-for-install.txt  >> $logfile
if [ $? -eq 0 ] 
then
    printf "ALL package installs completed succesfully.  \n\n" | tee -a $logfile
else 
    printf "=== FAILURE to install all packages ===\nCheck logs... \n" | tee -a $logfile
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


# Install chrome
echo "Installing chrome..." | tee -a $logfile
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >> $logfile
if [ $? -eq 0 ] 
then
    printf "Got download..  \n" | tee -a $logfile
else 
    printf "=== FAILURE to download chrome === \n" | tee -a $logfile
    if [ "$exitonfail" = true ]; 
    then
        echo "Exiting... see log for details" | tee -a $logfile
        exit 1
    fi
fi
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb  >> $logfile
if [ $? -eq 0 ] 
then
    printf "Installed.  \n" | tee -a $logfile
else 
    printf "=== FAILURE to install chrome === \n" | tee -a $logfile
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


# Install VSCode (needs repo dependency)
#ref: https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
echo "Installing vscode..." | tee -a $logfile
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -  >> $logfile
if [ $? -eq 0 ] 
then
    printf "Got download..  \n" | tee -a $logfile
else 
    printf "=== FAILURE to download chrome === \n" | tee -a $logfile
    if [ "$exitonfail" = true ]; 
    then
        echo "Exiting... see log for details" | tee -a $logfile
        exit 1
    fi
fi
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"  >> $logfile
sudo apt update  >> $logfile
sudo apt install -y code  >> $logfile
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Install VScode extensions
echo "Installing vscode extensions..." | tee -a $logfile
cat vscode-extensions-for-install.txt | while read line
do
    code --install-extension $line  >> $logfile
done
echo "Done. " | tee -a $logfile
if [ "$stepwise" = true ] ; 
then
    read -rsn1 -p"Press any key to continue";echo
fi

# Copy in vscode settings
echo "Copying vscode settings..."
mkdir -p ~/.config/Code/User/
cp vscode-settings.json ~/.config/Code/User/settings.json  >> $logfile
if [ $? -eq 0 ] 
then
    printf "Copied.  \n" | tee -a $logfile
else 
    printf "=== FAILURE to copy vscode settings === \n" | tee -a $logfile
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


echo "SETUP COMPLETE. If not run with -e, check for errors. " | tee -a $logfile