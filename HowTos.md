## Set system timezone
Check current timezone
```bash
timedatectl
```
List timezones
```bash
timedatectl list-timezones | grep "London"
```
Set timezone
```bash
timedatectl set-timezone Europe/London
```
My need to Ctrl+R for i3 to update timezone. 

## Set UK keyboard layout
```bash
setxkbmap -layout gb
```