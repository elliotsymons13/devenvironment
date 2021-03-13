# Purpose
Provide a personalised utility for syncing my own dotfiles between development machines, VMs as well as performing initial system setup for new environments. 


# Warnings
There are several limitations in it's current state:
 - Tested only on Ubuntu 20 and 18, using bash shell
 - Does not support hdpi displays well
 - Does not directly support OLED displays (brightness will be locked on full)
 - (The above two can be mitigated when running in a VM using host settings)

# Usage
Follow these instructions to configure the development environment on an Ubuntu 18LTS or 20 host. It has been roughly tested on each. The system must be installed as described below, in the $HOME directory. This will ensure dotfiles sit 'in place' and are used normally.

Install Ubuntu into VM/host as desired. Login. Run the GUI software updater to completion or not at all (to avoid dpkg lock conflicts). Restart as prompted and login again.

Now run the following commands to run the script. **Note that the script assumes it is run from it's own location (relative filepaths).** 

The below first sets up `config` as an alias allowing for git commands to be used to sync dotfiles between machines and Github. This process was based on an [attlasian tutorial](https://www.atlassian.com/git/tutorials/dotfiles) adn a [stackoverflow answer](https://stackoverflow.com/a/18999726)

```bash
alias config='/usr/bin/git --git-dir=$HOME/.devenv/.git --work-tree=$HOME'

cd ~
mkdir .devenv
config init
config remote add origin https://github.com/elliotsymons13/devenvironment.git
config fetch
config reset origin/master
config checkout master
config reset --hard 
config config --local status.showUntrackedFiles no

config status

cd ~/.devenv/
sudo chmod 755 ./dev-env-setup.sh 
./dev-env-setup.sh -e
```
Can optionally monitor detailed log with:
```bash
tail -f ~/devenvironment/dev-env-setup.log
```

*After this*, optionally install and configure i3 window manager with the following. **Note that this depends on several of the packages in the packages-to-install list, so the above must be run first.**

```bash
cd ~/devenvironment/
sudo chmod 755 ./i3-setup.sh
./i3-setup.sh
```

## Saving changes to dotfiles
If positive changes are made to dotfiles on one local system, then these can optionally be commited. 
The `config` alias is used in the same way as the normal git command, though can be run from any directory. 

For example, to save all changes to already tracked files (including dotfiles):
```bash
config status
config add -u
config status
config commit -m "Some descriptive message" 
config push
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

## Xresources: ~/.Xresources
This file is used to specify colours for import into the i3 config, and these same colours can be used by other programs e.g. terminal emulators for consistent theming. This is not yet implemented here. 

The following command must be used to reload the file for the changes to take effect
```bash
xrdb ~/.Xresources
```

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

# Icons

Using Font Awesome icons

Available: Font Awesome - release 5.15.2 [here](https://github.com/FortAwesome/Font-Awesome/commit/fcec2d1b01ff069ac10500ac42e4478d20d21f4c) download as ZIP, copy 3x main .ttf in `webfonts` subdir of download into ~/.fonts.

Add icons by selecting e.g. [here](https://fontawesome.com/cheatsheet) and pasting the icon ID into the i3 config or elsewhere. 