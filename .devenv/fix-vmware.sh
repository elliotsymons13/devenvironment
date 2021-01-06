# Fix vmware (if broken)
sudo apt remove open-vm-tools
sudo apt-get install open-vm-tools-desktop
vmware-user-suid-wrapper