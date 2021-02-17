#!/bin/bash
# Install customizations and apps for Pop!_OS Linux
# Knowing working for: Pop!_OS 20.10
# Other versions are likely to work


# Colors -- https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
declare cyan='\033[1;36m' # Light cyan
declare nc='\033[0m'      # No color
declare yel='\033[1;33m'  # Yellow
declare grn='\033[0;32m'  # Green
declare red='\033[0;31m'  # Red


echo -e "${cyan}*************************************************"
echo -e "**                                             **"
echo -e "**     ${yel}Pop!_OS Linux Customization Script${cyan}      **"
echo -e "**                                             **"
echo -e "*************************************************${nc}\n"


# Initial apt update
echo -e "\n\n${cyan}*****  Performing initial apt update  *****${nc}"
sudo apt update


# Password reminder
echo -e "\n\n${yel}# ${cyan}*****  ${yel}Please remember to change your password.  ${cyan}*****${nc}"
echo -e "\n\n"

# Desktop environment check
echo -e "\n${cyan}*****  Changing GDM login screen to use X11.  *****${nc}"
if [ -f /etc/gdm3/daemon.conf ]; then
    sudo -E sed -iE 's/^\#?\s?WaylandEnable=\s?true/WaylandEnable=false/' /etc/gdm3/daemon.conf
    echo -e "${yel}# ${grn}/etc/gdm3/daemon.conf modified.${nc}"
elif [ -f /etc/gdm/custom.conf ]; then
    sudo -E sec -iE 's/^\#?\s?WaylandEnable=\s?true/WaylandEnable=false/' /etc/gdm/custom.conf
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
if [ `which zsh` == 1 ]; then
    echo -e "${yel}# ${grn}Installing Zsh.${nc}"
    sudo apt install zsh
fi
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
sudo chsh --shell /usr/bin/zsh `whoami`
echo -e "\n\n"


# Apt installations
echo -e "${cyan}*****  Apt installations  *****${nc}"
echo -e "\n${yel}# ${grn}Performing Apt Install.${nc}"
sudo apt install \
    cowsay \
    dconf-editor \
    gnome-shell-extension-arc-menu \
    gnome-shell-extension-dash-to-panel \
    gnome-shell-extension-desktop-icons-ng \
    gnome-shell-extensions \
    gnome-sushi \
    gnome-tweaks
    lolcat \
    neofetch \
    powerline \
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
    xclip -y


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

echo -e "${yel}# ${grn}Enabling Desktop Icons NG.${nc}"
gnome-extensions enable ding@rastersoft.com

echo -e "${yel}# ${grn}Disabling Places Menu.${nc}"
gnome-extensions disable places-menu@gnome-shell-extensions.gcampax.github.com

# Clean up
# rm -rf $gnome_ext
echo -e "\n\n"


# Copy dotfiles to $HOME
echo -e "${cyan}*****  Copying dotfiles and Configuration  *****${nc}"
rsync -ax --exclude-from=$githome/linux_customizations/pop_os_exclude_list.txt $githome/linux_customizations/ $HOME
# mkdir -p $HOME/.local/share/backgrounds
# mv $HOME/kali_wallpaper.png $HOME/.local/share/backgrounds/
sudo -E cp $HOME/.vimrc /root  # To ensure VIM looks/works the same when sudo vim is used
chmod +x $HOME/Desktop/mount-shared-folders $HOME/Desktop/restart-vm-tools
# gsettings set org.gnome.desktop.background picture-uri file://$HOME/.local/share/backgrounds/kali_wallpaper.png  # Set wallpaper

# Set Gnome Favorites
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox-esr.desktop', 'terminator.desktop', 'org.gnome.gedit.desktop']"

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
        "https://addons.mozilla.org/firefox/downloads/file/3719054/ublock_origin-1.33.2-an+fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/898030/gnome_shell_integration-10.1-an+fx-linux.xpi",
        ""https://addons.mozilla.org/firefox/downloads/file/3650887/facebook_container-2.1.2-fx.xpi,
        ""https://addons.mozilla.org/firefox/downloads/file/3716461/https_everywhere-2021.1.27-an+fx.xpi,
        "https://addons.mozilla.org/firefox/downloads/file/3547888/imagus-0.9.8.74-fx.xpi",
        "https://addons.mozilla.org/firefox/downloads/file/3703195/reddit_enhancement_suite-5.20.12-an+fx.xpi"
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
