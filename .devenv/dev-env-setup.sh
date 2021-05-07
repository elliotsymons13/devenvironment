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
            echo "Will exit on first failure (you can confirm in each case)." | tee -a $logfile
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
function handle_previous_cmd_result() {
    # check if num params not expected
    if [ "$#" -ne 3 ];
    then
        echo "Invalid use of function. Exiting..." | tee -a $logfile
        exit 1
    fi

    # handle caller's command error handling
    if [ $1 -eq 0 ] 
    then
        printf "%s \n\n" "$2" | tee -a $logfile
    else 
        printf "=== FAILURE: %s === \n" "$3" | tee -a $logfile
        if [ "$exitonfail" = true ]; 
        then
            # Prompt to confirm exit or continue
            echo "Press e to exit or any other key to ignore and continue. The latter may cause further errors. "
            read -p "Exit?" exitchoice
            if [ "$exitchoice" = e ];
            then
                echo "Exiting... see log for details" | tee -a $logfile
                exit 1
            else
                echo "Continuing..."  | tee -a $logfile
                return
            fi
        fi
    fi
    if [ "$stepwise" = true ] ; 
    then
        read -rsn1 -p"Press any key to continue";echo
    fi
}



# Set timeout
echo "Setting screen timeout to 1 hour..." | tee -a $logfile
gsettings set org.gnome.desktop.session idle-delay 60
handle_previous_cmd_result $? "Sucessfully set screen timeout to 1 hour." "Could not set screen timeout"


# Setup keyboard - UK layout
#ref: https://askubuntu.com/questions/356763/setting-up-a-uk-keyboard-layout
echo "Setting keyboard layout to GB..." | tee -a $logfile
setxkbmap -layout gb
handle_previous_cmd_result $? "Sucessfully set GB keyboard layout." "Could not set GB keyboard layout"


# Set timezone
timedatectl set-timezone Europe/London
handle_previous_cmd_result $? "set timezone London. " "Could not set timezone"


# Update
echo "Running apt-get update... (long)" | tee -a $logfile
sudo apt-get update >> $logfile 2>&1
handle_previous_cmd_result $? "apt-get update completed." "Could not apt-get update"

# Upgrade
echo "Running apt-get upgrade... (longer)" | tee -a $logfile
sudo apt-get upgrade -y >> $logfile 2>&1
handle_previous_cmd_result $? "apt-get upgrade completed." "Could not apt-get upgrade"


# Install packages based on contents of packages-for-install.txt
# File must have LF line endings. 
echo "Installing packages from list..." | tee -a $logfile
xargs sudo apt-get install -y < packages-for-install.txt  >> $logfile 2>&1
handle_previous_cmd_result $? "Installed ALL packages sucessfully. " "Could not install one or more requested package. See $logfile for details. "


# Install chrome
# Download
echo "Installing chrome..." | tee -a $logfile
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >> $logfile 2>&1
handle_previous_cmd_result $? "Downloaded chrome sucessfully. " "Could not download chrome. "

# Install
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb  >> $logfile 2>&1
handle_previous_cmd_result $? "Installed chrome sucessfully. " "Could not install chrome. "

# Set chrome as default
sudo update-alternatives --config x-www-browser << EOF
0
EOF
echo #newline
handle_previous_cmd_result $? "Set chrome as default browser. " "Could not set default browser. "


# Install VSCode (needs repo dependency)
#ref: https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
echo "Installing vscode..." | tee -a $logfile
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -  >> $logfile 2>&1
handle_previous_cmd_result $? "Got vscode step 1/3..." "Could not get vscode"

sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"  >> $logfile 2>&1
handle_previous_cmd_result $? "Got vscode step 2/3..." "Could not get vscode"
sudo apt update  >> $logfile 2>&1
handle_previous_cmd_result $? "Got vscode step 3/3..." "Could not get vscode"
sudo apt install -y code  >> $logfile 2>&1
handle_previous_cmd_result $? "Installed vscode. " "Could not install vscode"


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

# Setup Gnome favorites bar
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'org.gnome.Terminal.desktop']"
handle_previous_cmd_result $? "Set favorites bar icons" "Could not set favorites bar icons"

echo "Installing docker..." | tee -a $logfile
# based on: https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release >> $logfile 2>&1
handle_previous_cmd_result $? "Installed docker dependencies" "Could not install docker dependencies"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
handle_previous_cmd_result $? "Downloaded docker gpg" "Could not download docker gpg"
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
handle_previous_cmd_result $? "Setup docker repository" "Could not setup docker repository"
sudo apt-get update
handle_previous_cmd_result $? "Apt update" "Could not apt update"
sudo apt-get install docker-ce docker-ce-cli containerd.io
handle_previous_cmd_result $? "Installed docker engine" "Could not install docker engine"
sudo docker run hello-world 
handle_previous_cmd_result $? "Docker tested - working" "Docker tested - not working"

echo "Installing docker-compose..." | tee -a $logfile
# based on: https://docs.docker.com/compose/install/
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
handle_previous_cmd_result $? "Downloaded docker compose binary" "Could not download docker compose binary"
sudo chmod +x /usr/local/bin/docker-compose
handle_previous_cmd_result $? "Made executable" "Could not make executable"
docker-compose --version
handle_previous_cmd_result $? "Docker compose installed sucesfully" "Docker-compose not installed or not executable"

echo "Installing docker-compose command complation..." | tee -a $logfile
# command completion for docker compose
# based on: https://docs.docker.com/compose/completion/
sudo curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.1/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
handle_previous_cmd_result $? "Installed bash command completion for docker compose" "Could not install bash command completion for docker compose"

echo "Installing golang..." | tee -a $logfile
sudo curl -L https://golang.org/dl/go1.16.4.linux-amd64.tar.gz -o /tmp/go.tar.gz
handle_previous_cmd_result $? "Downloaded go tar" "Could not download go tar"
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
handle_previous_cmd_result $? "Unpacked go" "Could not unpack go"
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
handle_previous_cmd_result $? "Added go to user path" "Could not add go to path"
go version
handle_previous_cmd_result $? "Tested go - working" "go is not installed, or not in path"

echo "SETUP COMPLETE. If not run with -e, check output and/or $logfile manually for errors (if you care). " | tee -a $logfile
