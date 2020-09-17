# linux_customizations
A compilation of customizations for Debian-based Linux distrubutions (mostly Pop!_OS and Kali Linux) and (finally) a mostly automated script to put everything in place.

![Preview 1](linux_customizations1.png?raw=true)
![Preview 2](linux_customizations2.png?raw=true)

> This script was written for my use case with VMware Workstation and the associated Kali Vm from Offensive Security. See the [VirtualBox section](#virtualbox-usage) below for getting copy/pase and window resizing functionality to work. I was unable to get file drag and drop to work between Windows host and Kali VirtualBox OVA guest.

## What's it do?
Here's what the automated script does:
1. Checks for and install Gnome desktop environment
2. Creates a ~/git directory with a symlink from /git -> ~/git for convenience
3. Clones this repository for support dotfiles, etc to ~/git
4. Installs Oh My Zsh with the Powerlevel10k theme, autosuggestions and syntax highlighting plugins
    - Type `exit` after the Zsh shell loads to exit zsh and continue the script
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
- beep
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
- source-highlight
- terminator
- vim-airline
- vim-gtk3
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

# Reasons
This started as an idea due to setting up a new VM with everything took time. Sure, I could use the default settings and install things as I needed them, but it also presented a fun project for a real-world issue... Boom! Learning opportunity.

# VirtualBox usage
Someone reached out to me with some issues that they were experiencing with the script and VirtualBox. After importing a fresh Kali VirtualBox OVA and running the kali_customization.sh script, the user was unable to resize the window, copy/paste text from host to guest and guest to host, or drag and drop files. I tried to track this down, and below is what I found. I use VMware Workstation normally so perhaps there is a better solution, but the below is working for everything except drag and drop.

Installed VirtualBox 6.1.14 and the VirtualBox 6.1.14 Oracle VM VirtualBox Extension Pack right from the VirtualBox website and downloaded a fresh copy of the Kali 2020.3 VirtualBox 64-bit image from Offensive Security.

Here's what I found so far:

1. Clean install and fresh VM everything worked, copy/paste and drag and drop in and out of VM, dynamic resolution resizing.
2. After the script, in Gnome Wayland clipboard copy/paste, drag and drop, and resizing were broken.
3. Switching to X11 from the login screen allowed for copy/paste and window resizing, but not drag and drop. The newer VMs default to Wayland.
    - This functionality was likely enabled by the `virtualbox-guest-x11` package, which is now installed in the VM though it wasn't previously and I did not specifically install it that I remember. Perhaps, an apt update and apt full-upgrade installed it and I didn't notice.
    - Switching back to Wayland, nothing works again.
4. Inserting the Guest Additions CD images (from VirtualBox Devices menu) and running that in Wayland allowed for copy/paste and window resizing to work, drag and drop still didn't work.
    - This required modifying the `/etc/fstab` file, removing `noauto` and adding `exec` to the line for the cdrom.

I wasn't able to get drag and drop to work no matter what I tried, unfortunately. Copy/paste and window resizing is working though.
