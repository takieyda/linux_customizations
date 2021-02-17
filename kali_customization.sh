#!/bin/bash
# Install customizations and apps for Kali Linux
# Knowing working for: 2020.3
# Other versions are likely to work


# Colors -- https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
declare cyan='\033[1;36m' # Light cyan
declare nc='\033[0m'      # No color
declare yel='\033[1;33m'  # Yellow
declare grn='\033[0;32m'  # Green
declare red='\033[0;31m'  # Red


echo -e "${cyan}*************************************************"
echo -e "**                                             **"
echo -e "**       ${yel}Kali Linux Customization Script${cyan}       **"
echo -e "**                                             **"
echo -e "*************************************************${nc}\n"


# Initial apt update
echo -e "\n\n$${cyan}*****  Performing initial apt update  *****${nc}"
sudo apt update


# Password reminder
echo -e "\n\n${yel}# ${cyan}*****  ${yel}Please remember to change your password.  ${cyan}*****${nc}"
echo -e "\n\n"


# Desktop environment check
echo -e "${cyan}*****  Checking for the Gnome desktop environment.  *****${nc}\n"
if [ $XDG_CURRENT_DESKTOP != "GNOME" ]; then
    echo -e "${red}! *****  ${cyan}Gnome not found. Most changes in this script are Gnome specific.  ${red}*****${nc}"
	echo -e "${red}! *****           ${yel}Please install the Gnome desktop environment.            ${red}*****${nc}\n"
    
    while : ; do  # Infinite while loop
        read -n 1 -p "Do you want to install Gnome now? [Y/n] " ans
        case $ans in
            [Yy]*|"" ) echo -e "\n"; sudo apt install gnome -y; break;;
            [Nn]* ) echo -e "\n\n${yel}# ${cyan}Most changes in this script are Gnome specific. ${red}Exiting script...${nc}\n"; exit;;
            * ) echo -e "\n${yel}# ${cyan}Please choose ${yel}Yes ${cyan}or ${yel}No${cyan}.${nc}\n"
        esac
    done
fi

echo -e "\n${cyan}*****  Changing GDM login screen to use X11.  *****${nc}"
if [ -f /etc/gdm3/daemon.conf ]; then
    sudo -E sed -iE 's/^\#?\s?WaylandEnable=\s?true/WaylandEnable=false/' /etc/gdm3/daemon.conf
    echo -e "${yel}# ${grn}/etc/gdm3/daemon.conf modified.${nc}"
elif [ -f /etc/gdm/custom.conf ]; then
    sudo -E sed -iE 's/^\#?\s?WaylandEnable=\s?true/WaylandEnable=false/' /etc/gdm/custom.conf
    echo -e "${yel}# ${grn}/etc/gdm/custom.conf modified.${nc}"
else
    echo -e "${red}! *****  ${cyan}GDM configuration file not found.  ${red}*****${nc}"
    echo -e "${red}! ${cyan}A black screen may appear to the user when using VMware Workstation and Wayland.
    ${red}! ${cyan}Please check for these files and manually edit them to disable Wayland to
    ${red}! ${cyan}fix this issue.${nc}"
fi
echo -e "\n\n"


# Create ~/git directory, set $githome, and download dotfiles
# If conditions -- https://linuxize.com/post/bash-check-if-file-exists/#:~:text=How%20to%20Check%20if%20a%20File%20or%20Directory,exists%20and%20determine%20the%20type%20of%20the%20file.
echo -e "${cyan}*****  Git setup  *****${nc}"  # -e required for echo to enable backslash escapes
if [ ! -d $HOME/git ]; then
    mkdir $HOME/git
else
    echo -e "${yel}# ${grn}$HOME/git already exists.${nc}"
fi
if [ ! -d /git ]; then
    sudo ln -s $HOME/git /git
else
    echo -e "${yel}# ${grn}Symlink /git to $HOME/git already exists.${nc}"
fi
declare githome=$HOME/git
git clone https://github.com/takieyda/linux_customizations $githome/linux_customizations
echo -e "${cyan}User:\t ${yel}`whoami`"
echo -e "${cyan}HOME:\t ${yel}$HOME"
echo -e "${cyan}GITHOME: ${yel}$githome${nc}"
echo -e "\n\n"


# Install Oh-My-Zsh and plugins
echo -e "${cyan}*****  Oh My Zsh setup  *****${nc}"
if [ ! -d $HOME/.oh-my-zsh ]; then
    # Have to manually exit zsh to continue
    # echo -e "\n\n${yel}# ${cyan}*****  Type ${yel}exit${cyan} after Zsh loads to continue script  *****${nc}"
    # read -n 1 -r -p "Press any key to continue..."
    #echo -e "\n\n"

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${yel}# ${grn}Oh My Zsh already installed.${nc}"
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sudo chsh --shell /usr/bin/zsh kali
echo -e "\n\n"


# Apt installations
echo -e "${cyan}*****  Apt installations  *****${nc}"
echo -e "\n${yel}# ${grn}Performing Apt Install.${nc}"
sudo apt install \
    alien \
    beep \
    bloodhound \
    cowsay \
    dconf-editor \
    gnome-shell-extension-arc-menu \
    gnome-shell-extension-dash-to-panel \
    gnome-shell-extension-desktop-icons \
    gnome-shell-extension-easyscreencast \
    gnome-shell-extension-proxyswitcher \
    gnome-shell-extensions \
    gnome-sushi \
    gobuster \
    lolcat \
    neofetch \
    powerline \
    python-pip \
    python3-argcomplete \
    python3-pip \
    ranger \
    source-highlight \
    terminator \
    tmux-plugin-manager \
    vim-airline \
    vim-airline-themes \
    vim-gtk3 \
    wxhexeditor \
    xclip \
    zaproxy -y
    
# Setup beep command
echo -e "\n${yel}# ${grn}Configuring and adding ${yel}`whoami` ${grn}to the beep user group.${nc}"
sudo groupadd --system beep
sudo usermod -aG beep `whoami`

# Install Zenmap
# ZenMap (as Root) shortcut doesn't seem to work, considering replacing it with sudo -E zenmap
echo -e "\n${yel}# ${grn}Installing Zenmap GUI.${nc}"
if [ ! -f /usr/bin/zenmap ]; then
    wget "https://nmap.org/dist/zenmap-7.80-1.noarch.rpm" -O /tmp/zenmap.rpm
    #curdir=`pwd`
    cd /tmp
    sudo alien zenmap.rpm -i
    rm /tmp/zenmap*
    cd - #$curdir
else
    echo -e "${yel}# ${cyan}Zenmap already installed.${nc}"
fi
echo -e "\n\n"


# GitHub Repo clones
# BASH arrays -- https://www.linuxjournal.com/content/bash-arrays
# BASH For loops -- https://linuxhint.com/bash_loop_list_strings/
echo -e "${cyan}*****  GitHub installations  *****${nc}"
declare -a repos=( \
    SecureAuthCorp/impacket \
    411Hall/JAWS \
    rebootuser/LinEnum \
    sleventyeleven/linuxprivchecker \
    diego-treitos/linux-smart-enumeration \
    TsukiCTF/Lovely-Potato \
    samratashok/nishang \
    besimorhino/powercat \
    PowerShellMafia/PowerSploit \
    carlospolop/privilege-escalation-awesome-scripts-suite \
    0x00-0x00/ShellPop \
    absolomb/WindowsEnum \
)

echo -e "${yel}# ${grn}Cloning repos...${nc}"
for repo in ${repos[@]}
do
    # In awk -F sets field separator, $NF returns number of fields choosing last element
    git clone https://github.com/$repo $githome/$(echo $repo | awk -F '/' '{print $NF}')
done

# Impacket
echo -e "\n${yel}# ${grn}Installing impacket.${nc}"
cd $githome/impacket
python3 -m pip install .
cd - #$curdir  # Set at ln 74

#ShellPop
echo -e "\n${yel}# ${grn}Installing ShellPop.${nc}"
cd $githome/ShellPop
python -m pip install wheel
python -m pip install -r requirements.txt
sudo -E python setup.py install  # Will fail if CWD is not repo root directory
cd - #$curdir
echo -e "\n\n"


# Other installs

# AutoRecon
echo -e "${cyan}*****  AutoRecon installation  *****${nc}"
python3 -m pip install git+https://github.com/Tib3rius/AutoRecon.git
echo -e "\n\n"

# Evil-WinRM
echo -e "${cyan}*****  Evil-WinRM installation  *****${nc}"
sudo -E gem install evil-winrm
echo -e "\n\n"


# Install Gnome extensions -- https://linuxconfig.org/install-gnome-shell-extensions-from-zip-file-using-command-line-on-ubuntu-20-04-linux
echo -e "${cyan}*****  Gnome extenions installation  *****${nc}"
# mkdir /tmp/gnome_extensions
# declare gnome_ext=/tmp/gnome_extensions

echo -e "${yel}# ${grn}Disabling Applications Menu.${nc}"
gnome-extensions disable apps-menu@gnome-shell-extensions.gcampax.github.com

echo -e "${yel}# ${grn}Enabling Arc Menu.${nc}"
gnome-extensions enable arc-menu@linxgem33.com

echo -e "${yel}# ${grn}Enabling Dash to Panel.${nc}"
gnome-extensions enable dash-to-panel@jderose9.github.com

echo -e "${yel}# ${grn}Enabling Desktop Icons.${nc}"
gnome-extensions enable desktop-icons@csoriano

echo -e "${yel}# ${grn}Enabling Easy ScreenCast Recorder${nc}"
gnome-extensions enable EasyScreenCast@iacopodeenosee.gmail.com

echo -e "${yel}# ${grn}Disabling Places Menu.${nc}"
gnome-extensions disable places-menu@gnome-shell-extensions.gcampax.github.com

echo -e "${yel}# ${grn}Enabling Proxy Switcher.${nc}"
gnome-extensions enable ProxySwitcher@flannaghan.com

# Clean up
# rm -rf $gnome_ext
echo -e "\n\n"


# Copy dotfiles to $HOME
echo -e "${cyan}*****  Copying dotfiles and Configuration  *****${nc}"
rsync -ax --exclude-from=$githome/linux_customizations/rsync_exclude_list.txt $githome/linux_customizations/ $HOME
mkdir -p $HOME/.local/share/backgrounds
mv $HOME/kali_wallpaper.png $HOME/.local/share/backgrounds/
sudo -E cp $HOME/.vimrc /root  # To ensure VIM looks/works the same when sudo vim is used
chmod +x $HOME/Desktop/mount-shared-folders $HOME/Desktop/restart-vm-tools
gsettings set org.gnome.desktop.background picture-uri file://$HOME/.local/share/backgrounds/kali_wallpaper.png  # Set wallpaper

# Set Gnome Favorites
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox-esr.desktop', 'terminator.desktop', 'org.gnome.gedit.desktop', 'kali-msfconsole.desktop', 'kali-burpsuite.desktop', 'cherrytree.desktop']"

# Custom key bindings -- https://techwiser.com/custom-keyboard-shortcuts-ubuntu/
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'System Monitor'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Primary><Shift>Escape'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gnome-system-monitor'"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Terminator'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Super>t'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'terminator'"

# Disable Emjoi hotkey Ctrl-Shift-e -- https://forum.level1techs.com/t/gnome-disable-emoji-keyboard-shortcut-ctrl-shift-e/130351/10
gsettings set org.freedesktop.ibus.panel.emoji hotkey []

# Gedit Dracula Theme
mkdir -p $HOME/.local/share/gedit/styles/
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml -O $HOME/.local/share/gedit/styles/dracula.xml
gsettings set org.gnome.gedit.preferences.editor scheme "'dracula'"

# VIM Dracula Theme
mkdir -p ~/.vim/pack/themes/start
git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula

# User theme
gsettings set org.gnome.shell.extensions.user-theme name "'Kali-Dark'"
gsettings set org.gnome.desktop.interface gtk-theme "'Mc-OS-Transparent-1.3'"

# Default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec "'terminator'"
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-x'"

# Automatic screen lock
gsettings set org.gnome.desktop.screensaver lock-enabled "false"
echo -e "\n"

# Arc Menu and Dash to Panel customization -- https://developer.gnome.org/dconf/unstable/dconf-tool.html
echo -e "${cyan}*****  Arc Menu customizations  *****${nc}\n"
dconf load /org/gnome/shell/extensions/arc-menu/ < $HOME/arc_menu_settings.txt
echo -e "${cyan}*****  Dash to Panel customizations  *****${nc}\n"
dconf load /org/gnome/shell/extensions/dash-to-panel/ < $HOME/dash_to_panel_settings.txt
rm arc_menu_settings.txt dash_to_panel_settings.txt


# Firefox extensions -- https://github.com/mozilla/policy-templates/blob/master/README.md#extensions
echo -e "${cyan}*****  Firefox extension installation  *****${nc}"
file=/usr/share/firefox-esr/distribution/policies.json
src=`head -n -3 $file`
ext='    },
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/file/3343599/cookie_quick_manager-0.5rc2-an+fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/3616824/foxyproxy_standard-7.5.1-an+fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/3398269/max_hackbar-4.7-fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/898030/gnome_shell_integration-10.1-an+fx-linux.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/3384326/http_header_live-0.6.5.2-fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/3618861/wappalyzer-6.2.3-fx.xpi"
      ]
    }
  }
}'
output=`echo -e "$src\n$ext"`
echo -e "${yel}# ${grn}Original file backed up:${yel} $file.bak${nc}"
if [ ! -f $file.bak ]; then
    sudo mv $file $file.bak
else
    echo -e "${yel}# Backup file already exists${nc}"
fi
echo -e "$output" > /tmp/policies.json
sudo mv /tmp/policies.json $file
sudo chown root:root $file
echo -e "\n\n"


source $HOME/.bashrc

echo -e "${cyan}*****  ${green}Customization complete  ${cyan}*****${nc}"
echo -e "${yel}Please review output for any errors!${nc}\n\n"
echo -e "${yel}###   Please REBOOT for some changes to take effect   ###${nc}\n\n"


while : ; do
    read -n 1 -p "Do you want to reboot now? [Y/n] " ans
    case $ans in
        [Yy]*|"" ) echo -e "\n"; sudo reboot;;
        [Nn]* ) echo -e "\n\n"; break;;
        * ) echo -e "${yel}# ${cyan}Please choose ${yel}Yes ${cyan}or ${yel}No${cyan}.${nc}"
    esac
done
