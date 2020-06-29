# Purpose

# Usage
To install dev environment basics, assuming Ubuntu 1804 (tested). 

Install ubuntu on VM/host, then clone down this repo and run:
```bash
sudo dev-environment-setup.sh
```

After this, optionally install and configure i3 with:

```bash
TODO
```

# File descriptions
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
