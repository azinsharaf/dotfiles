#!/bin/bash
set -euo pipefail

# Focused Arch Linux package list — add/remove entries here.
packages=(
    # Shell & prompt
    zsh
    starship
    zoxide
    fzf
    atuin

    # File listing & search
    eza
    bat
    fd
    ripgrep
    tree

    # Terminal multiplexers
    zellij
    tmate

    # Dev & git
    neovim
    lazygit
    git-delta
    gh
    jq
    yq

    # File manager & viewer
    yazi
    glow

    # System info
    btop
    fastfetch
    procs
    dust

    # Docs
    tldr
    man-db
    man-pages

    # Utilities
    hyperfine
    just
    rclone
    rsync

    # Security
    bitwarden-cli
    gnupg
    age

    # Herdr — AI-powered terminal assistant
    herdr
)

# Install via omarchy if available, else pacman
if command -v omarchy &>/dev/null; then
    omarchy pkg add "${packages[@]}"
else
    sudo pacman -S --needed --noconfirm "${packages[@]}"
fi
