#!/bin/bash

# Script to automatically install packages on Arch Linux
# Usage: ./install-aur-packages.sh

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# List of AUR packages to install
AURPACKAGES=(
    aylurs-gtk-shell
    bibata-cursor-theme-bin
    brave-bin
    discord-canary
    grimblast-git
    pacseek
    vscodium-bin
)

echo -e "${GREEN}Installing AUR packages...${RESET}"
for AURPACKAGE in "${AURPACKAGES[@]}"; do
    if paru -S "$AURPACKAGE" --noconfirm; then
        echo -e "${GREEN}$AURPACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $AURPACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All AUR packages installed successfully...${RESET}"