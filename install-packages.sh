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
    cmatrix genact
)

echo -e "${GREEN}Installing packages...${RESET}"
for PACKAGE in "${PACKAGES[@]}"; do
    if pacman -S "$PACKAGE"; then
        echo -e "${GREEN}$PACKAGE installed successfully.${RESET}"
    else
        echo -e "${RED}Failed to install $PACKAGE.${RESET}"
    fi
done
echo -e "${GREEN}All tasks completed successfully.${RESET}"
