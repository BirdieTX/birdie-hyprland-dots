#!/bin/bash

# Script to automatically install packages on Fedora 41
# Usage: ./install-packages.sh

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root or use sudo.${RESET}"
    exit 1
fi

echo -e "${GREEN}Updating system packages...${RESET}"
dnf update -y

# Add Brave Browser repository
echo -e "${GREEN}Installing dnf-plugins-core and adding Brave Browser repository...${RESET}"
if dnf install -y dnf-plugins-core; then
    echo -e "${GREEN}dnf-plugins-core installed successfully.${RESET}"
else
    echo -e "${RED}Failed to install dnf-plugins-core.${RESET}"
    exit 1
fi

if dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo; then
    echo -e "${GREEN}Brave Browser repository added successfully.${RESET}"
else
    echo -e "${RED}Failed to add Brave Browser repository.${RESET}"
    exit 1
fi

# Add Codium repository
echo -e "${GREEN}Adding Codium RPM Keys...${RESET}"
if rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg; then
    echo -e "${GREEN}Codium RPM Keys added successfully.${RESET}"
else
    echo -e "${RED}Failed to import Codium RPM Keys.${RESET}"
    exit 1
fi

if printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo; then
    echo -e "${GREEN}Codium Repository added successfully.${RESET}"
else
    echo -e "${RED}Failed to add Codium Repository.${RESET}"
    exit 1
fi

# Adding Bibata Cursor repository
echo -e "${GREEN}Adding Bibata cursor repository...${RESET}"
if dnf copr enable peterwu/rendezvous; then
    echo -e "${GREEN}Bibata Cursor Repository added successfully${RESET}"
else
    echo -e "${RED}Failed to import Bibata Cursor Repository.${RESET}"
    exit 1
fi

# List of packages to install
PACKAGES=(
    neovim
    fastfetch
    htop
    btop
    flatpak
    brave-browser
    codium
    zfs-fuse
    xhost
    fish
    qalculate-gtk
    libnotify
    dunst
    mediawriter
    nautilus
    kitty
    hyprland
    hyprpaper
    xdg-desktop-portal-hyprland
    qt5-qtwayland
    qt6-qtwayland
    xdg-desktop-portal-gtk
    brightnessctl
    nm-connection-editor
    gtk4
    libadwaita
    blueman
    qt6ct
    waybar
    rofi-wayland
    pavucontrol
    papirus-icon-theme
    bibata-cursor-themes 
    flatpak
    NetworkManager-tui
    grub-customizer
    simple-scan
    gnome-characters
    audacity
    evince
    flatseal
    gimp
    kdenlive
    loupe
    solaar
    remmina
    libreoffice-writer
    libreoffice-calc
    libreoffice-impress
    libreoffice-draw
    libreoffice-math
    vlc
    obs-studio
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

)

echo -e "${GREEN}Installing packages...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if dnf install -y "$PACKAGE"; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done

# Post-installation steps
echo -e "${GREEN}Setting up Flatpak remote for Flathub...${RESET}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "${GREEN}Cleaning up...${RESET}"
dnf autoremove -y
dnf clean all

echo -e "${GREEN}All tasks completed successfully.${RESET}"