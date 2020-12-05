# Purpose

# Usage
To install dev environment basics, assuming Ubuntu 1804 LTS (tested here only, but may work on others). 
# TODO tested on Ubuntu 20??

Install Ubuntu into VM/host as desired. Login. Run the GUI software updater to completion (to avoid dpkg lock conflicts). Restart as prompted and login again.

Now run the following commands:

```bash
sudo apt-get install -y git # enter password as prompted
git clone https://github.com/elliotsymons13/devenvironment.git
cd ~/devenvironment/
sudo chmod 755 ./dev-env-setup.sh 
./dev-environment-setup.sh -e -s
```
Can optionally monitor detailed log with:
```bash
tail -f ~/devenvironment/dev-env-setup.log
```

*After this*, optionally install and configure i3 window manager with:

```bash
cd ~/devenvironment/
sudo chmod 755 ./i3-setup.sh
./i3-setup.sh
```

# Config descriptions
## i3 config: ~/.config/i3/config

Colours can be changed in the ~/.Xresources file. The following command must be used to reload the file for the changes to take effect
```bash
xrdb ~/.Xresources
```
These colours can then be inherited in the i3 config file using commands such as
```bash
set_from_resource $accent1 accent1
```
where the last value is the name in the .Xresources file. A default can optionally be given after this, in #000000 format. Other applications can inherit the same colour values from .Xresources where supported. 

## Xresrouces: ~/.Xresources
This file is used to specify colours for import into the i3 config, and can be used by other programs Eg terminal emulators for consistent theming (not yet implemented here). 

## i3status config: ~/.config/i3status/config
Used to specify the format and content of the status bar. Alternatives offer more functionality, e.g. i3blocks, but I didn't see them as necessary yet. 


# List descriptions
## vscode-extensions-for-install.txt
This file lists all extension names, and can be used to programatically install a desired set of extensions as shown below. Must use unix line endings (LF not CRLF). 


The list is derived from the results of running the following on an already-setup and configured instance of vscode. This is platform independent, Windows or Linux. 

```bash
code --list-extensions
```

## packages-for-install.txt
This file lists all packages (programs) that are to be programatically installed, as below. Must use unix line endings (LF not CRLF).


This list is derived from the results of running the following on a desired system setup, which shows manually installed programs (linux). 

```bash
apt-mark showmanual
```
