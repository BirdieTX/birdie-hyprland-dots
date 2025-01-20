#!/bin/bash

# Script to automatically install packages on Arch Linux
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
pacman -Syu

# List of packages to install
PACKAGES=(
    blueman
    breeze
    btop
    cliphist
    cmatrix
    dunst
    fastfetch
    figlet
    fish
    fzf
    eza
    genact
    grim
    grub-customizer
    gtk4
    gvfs
    kitty
    htop
    hyprland
    imagemagick
    jq
    libadwaita
    libnotify
    man-pages
    mc
    mesa
    nautilus
    neovim
    noto-fonts
    otf-font-awesome
    papirus-icon-theme
    pavucontrol
    pipewire
    polkit-gnome
    pulseaudio
    qalculate-gtk
    qt5-wayland
    qt6-wayland
    qt6ct
    rofi-wayland
    slurp
    ttf-fira-code
    ttf-fira-mono
    ttf-fira-sans
    ttf-firacode-nerd
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    tumbler
    vulkan-radeon
    waybar
    wireplumber
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-user-dirs
    xhost
)

echo -e "${GREEN}Installing packages...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if pacman -S "$PACKAGE" --noconfirm; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All packages installed successfully...${RESET}"