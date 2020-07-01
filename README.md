# Purpose

# Usage
To install dev environment basics, assuming Ubuntu 1804 LTS (tested here only, but may work on others). 

Install ubuntu on VM/host, then clone down this repo. Copy it onto VM desktop, then run:
```bash
cd Desktop/DevEnvSetup/
./dev-environment-setup.sh -e -s
```
Can optionally monitor detailed log with:
```bash
tail -f ~/Desktop/DevEnvSetup/dev-env.setup.log
```

*After this*, optionally install and configure i3 with:

```bash
./i3-setup.sh
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
