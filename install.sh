#!/bin/bash

# Vars
TEMP_DIR=$(mktemp -d) || { echo "Failed to create temp directory"; exit 1; }
YAY_URL="https://aur.archlinux.org/yay-git.git"
DOTFILES_URL="https://github.com/jorgerxbio/dotfiles"

# function to install pacman packages
install_pacman_packages(){
  for package in "$@"; do
    if ! pacman -Q "$package" &>/dev/null; then
      echo "installing $package..."
      sudo pacman -S --noconfirm "$package"
    else
      echo "$package is already installed"
    fi
  done
}

# function to install yay packages
install_yay_packages() {
  for package in "$@"; do
    if ! yay -Q "$package" &>/dev/null; then
      echo "Installing $package..."
      yay -S --noconfirm "$package"
    else
      echo "$package is already installed"
    fi
  done
}
# install system packages
install_pacman_packages brightnessctl cbatticon diskie git gtk3 kitty libnotify network-manager-applet notification-daemon ntfs-3g pamixer pavucontrol picom pulse-audio python-psutil rofi scrot tree unzip volumeicon xclip xorg xorg-xinit yazi 

# install apps
install_pacman_packages discord lxappearance neofetch neovim obsidian

# install fonts
install_pacman_packages ttf-jetbrains-mono-nerd

# install yay
if ! pacman -Q "yay"; then
  git clone "$YAY_URL" "$TEMP_DIR/yay-git/" || { echo "Failed to clone repo"; exit 1; }
  cd "$TEMP_DIR/yay-git/" || { echo "Failed to enter directory"; exit 1; }
  makepkg -si || { echo "Build and install failed"; exit 1; }
else
  echo "yay is already installed"
fi

# install yay packages
install_yay_packages spotify

# Set up dotfiles
git clone --depth 1  "$DOTFILES_URL" "$TEMP_DIR/dotfiles"

if [ ! -d "$HOME/.config/qtile/" ]; then
  mkdir "$HOME/.config/qtile/"
else
  echo "$HOME/.config/qtile directory already exists"
fi

if [ ! -d "$HOME/.config/kitty/" ]; then
  mkdir "$HOME/.config/kitty/"
else
  echo "$HOME/.config/kitty directory already exists"
fi

cp -r "$TEMP_DIR/dotfiles/.config/qtile/"* "$HOME/.config/qtile/"
cp -r "$TEMP_DIR/dotfiles/.config/kitty/"* "$HOME/.config/kitty/"

cp "$TEMP_DIR/dotfiles/.bashrc" "$HOME"
