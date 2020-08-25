# linux_customizations
A compilation of customizations for Debian-based Linux distrubutions (mostly Pop!_OS and Kali Linux) and (finally) a mostly automated script to put everything in place.

![Preview 1](linux_customizations1.png?raw=true)
![Preview 2](linux_customizations2.png?raw=true)

## What's it do?
Here's what the automated script does:
1. Checks for and install Gnome desktop environment
2. Creates a ~/git directory with a symlink from /git -> ~/git for convenience
3. Clones this repository for support dotfiles, etc to ~/git
4. Installs Oh My Zsh with the Powerlevel10k theme, autosuggestions and syntax highlighting plugins
5. Apt installs a number of my commonly used packages
    - Along with Zenmap for occasionaly usage (Zenmap as Root application shortcut isn't currently working, but sudo -E zenmap does.)
6. Git clones a number of my commonly used repos and installs/configures as needed
7. Installs Gnome extensions
    - Applicaiton Menu and Places Indicator extensions are disabled and will not enable via Tweaks, use Dconf-Editor, dconf, or gnome-extensions to enable and then they can be enabled/disabled from Tweaks
8. Copies dotfiles and applies customizations via gsettings
    - Wallpaper, favorite apps, keybindings, disables emoji shortcut key for compatibility with Terminator, sets themes
9. Installs a number of my commonly used Firefox extensions

## What's it install?
### Apt packages
- gnome
- alien
- bloodhound
- cowsay
- dconf-editor
- gnome-shell-extension-arc-menu
- gnome-shell-extension-dash-to-panel
- gnome-shell-extension-desktop-icons
- gnome-shell-extension-easyscreencast
- gnome-shell-extension-proxyswitcher
- gnome-shell-extensions
- gnome-sushi
- lolcat
- neofetch
- powerline
- python-pip
- python3-argcomplete
- python3-pip
- ranger
- terminator
- vim-airline
- wxhexeditor
- xclip
- zaproxy
- zenmap

### Firefox extensions
- Cookie Quick Manager
- FoxyProxy Standard
- Max HackBar
- Gnome Shell Integration
- HTTP Header Live
- Wappalyzer

### GitHub repos
- SecureAuthCorp/impacket
- 411Hall/JAWS
- rebootuser/LinEnum
- sleventyeleven/linuxprivchecker
- diego-treitos/linux-smart-enumeration
- TsukiCTF/Lovely-Potato
- samratashok/nishang
- besimorhino/powercat
- PowerShellMafia/PowerSploit
- carlospolop/privilege-escalation-awesome-scripts-suite
- 0x00-0x00/ShellPop
- absolomb/WindowsEnum

## Keyboard Shortcuts
- <kbd>Super</kbd>+<kbd>t</kbd> - Open Terminator
- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Esc</kbd> - Open Gnome System Monitor
