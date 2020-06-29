#!/bin/bash/
# MUST BE RUN AS ROOT
# TODO  check root status here

# Setup keyboard - UK layout
#ref: https://askubuntu.com/questions/356763/setting-up-a-uk-keyboard-layout
setxkbmap -layout gb  

sudo apt-get update
sudo apt-get upgrade -y

# Install packages
# File must have LF line endings. 
xargs sudo apt-get install -y < packages-for-install.txt

# Install VSCode (needs repo dependency)
#ref: https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

# Install VScode dependencies
cat vscode-extensions-for-install.txt | while read line
do
    code --install-extension $line
done

