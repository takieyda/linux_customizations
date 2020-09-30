#!/bin/bash
# Install customizations and apps for Ubuntu Server
# Known working for: 20.04.1 LTS


# Colors -- https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
declare cyan='\033[1;36m' # Light cyan
declare nc='\033[0m'      # No color
declare yel='\033[1;33m'  # Yellow
declare grn='\033[0;32m'  # Green
declare red='\033[0;31m'  # Red


echo -e "${cyan}*************************************************"
echo -e "**                                             **"
echo -e "**       ${yel}Server Linux Customization Script${cyan}       **"
echo -e "**                                             **"
echo -e "*************************************************${nc}\n"


# Initial apt runs
echo -e "\n\n${cyan}*****  Performing initial apt tasks  *****${nc}"
sudo apt update
sudo apt full-upgrade -y

# Password reminder
echo -e "\n\n${yel}# ${cyan}*****  ${yel}Please remember to change your password.  ${cyan}*****${nc}"
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
if [ ! -f /bin/zsh ]; then
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
sudo chsh --shell /bin/zsh $USER
echo -e "\n\n"


# Apt installations
echo -e "${cyan}*****  Apt installations  *****${nc}"
echo -e "\n${yel}# ${grn}Performing Apt Install.${nc}"
sudo apt install \
    neofetch \
    powerline \
    python-pip-whl \
    python3-argcomplete \
    python3-pip \
    ranger \
    source-highlight \
    vim-airline \
    vim-gtk3 \
    xclip -y
    
# Vim Dracula theme download
mkdir -p $HOME/.vim/pack/themes/start
git clone https://github.com/dracula/vim.git dracula $HOME/.vim/pack/themes/start/

# Copy dotfiles to $HOME
echo -e "${cyan}*****  Copying dotfiles and Configuration  *****${nc}"
rsync -ax --exclude-from=$githome/linux_customizations/server_exclude_list.txt $githome/linux_customizations/ $HOME
sudo -E cp $HOME/.vimrc /root  # To ensure VIM looks/works the same when sudo vim is used


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
