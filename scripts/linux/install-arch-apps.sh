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

    # Languages & build
    go
    nodejs
    npm
    lua
    luarocks
    perl
    gcc
    make

    # Formatters
    stylua

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

    # Media
    ffmpeg
    imagemagick
    pandoc
    yt-dlp
    mpv

    # Archives
    p7zip
    unzip
    zip

    # Terminal extras
    carapace
    television
    hexyl
    broot
    chafa

    # Database
    usql

    # Browser
    qutebrowser

    # Utilities
    hyperfine
    just
    rclone
    rsync
    speedtest-cli
    exiftool
    mediainfo

    # Security
    bitwarden-cli
    gnupg
    age

    # AI
    herdr
    opencode
)

# Install via omarchy if available, else pacman
if command -v omarchy &>/dev/null; then
    omarchy pkg add "${packages[@]}"
else
    sudo pacman -S --needed --noconfirm "${packages[@]}"
fi
