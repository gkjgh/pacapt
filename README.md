## sapt for Simple APT
Tools for people who prefer to or has to use command line for maintaining system and familiar with pacman.<br/>
Reference: [Pacman/Rosetta](https://wiki.archlinux.org/index.php/Pacman/Rosetta)

## File Description and Position Suggests
pacman: Arch Linux package manager.<br/>
directory: /usr/local/bin/

_pacman: pacman for zsh completion<br/>
directory: /usr/local/share/zsh/site-functions/

MIP: manually installed packages. Depends on deborphan.<br/>
directory: /usr/local/bin/

base-packages: customize base packages.<br/>
directory: /usr/local/etc/

## about MIP
This is a tool for finding out top packages and checking out dependcies. "top" means the package is not required by any other packages. Top and base packages should be manually installed, otherswise should be automaticly installed. So after correct the "Installed Reason", which can be seen with "pacman -Qi", administrator can purge the whole tree with "pacman -Rns" without any leaves (trash) packages.

Parameter ex for showing automaticly installed recommends packages and base packages.<br/>
Example:<br/>
\# ~/bin/MIP > mip<br/>
\# vim mip<br/>
\# sudo apt-mark auto ${pkgs_should_be_auto_showing_in_mip_file}<br/>
\# sudo pacman -Rns ${top_pkg_you_want_to_purge_recursively}
