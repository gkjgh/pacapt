## eapt for easy apt
Tools for people who prefer to use command line and familiar with pacman.<br/>
Reference: [Pacman/Rosetta](https://wiki.archlinux.org/index.php/Pacman/Rosetta)

## File Description and Position Suggests
pacman: Arch Linux package managerment tool.<br/>
dir: /bin/

_pacman: pacman for zsh completion<br/>
dir: /usr/share/zsh/functions/Completion/Debian/ (Debian8) or /usr/share/zsh/site_functions/ (Arch)

MIP: manually installed packages. Depends on deborphan.<br/>
dir: ~/bin/

base-packages: customize base packages.<br/>
dir: must be the same as MIP.

## about MIP
This is a tool for find out top packages and check out dependcies. "top" means the package is not required by any other packages. It should be manually installed, otherswise should be automaticly installed. So after correct the "Installed Reason", administrator can purge the whole tree with "pacman -Rns" without any leaves (trash) packages.
