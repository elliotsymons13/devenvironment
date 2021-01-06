

From https://www.atlassian.com/git/tutorials/dotfiles and https://stackoverflow.com/a/18999726
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


```
