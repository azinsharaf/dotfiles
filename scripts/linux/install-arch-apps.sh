#!/bin/bash
set -euo pipefail

# ── Main repo packages (Arch/OPR) ──
main_packages=(
    zsh starship zoxide fzf atuin
    eza bat fd ripgrep tree
    zellij tmate
    neovim lazygit git-delta gh jq yq
    go nodejs npm lua luarocks perl gcc make
    stylua
    yazi glow
    btop fastfetch procs dust
    tldr man-db man-pages
    ffmpeg imagemagick pandoc yt-dlp mpv
    p7zip unzip zip
    hexyl broot chafa
    usql
    qutebrowser
    hyperfine just rclone rsync
    speedtest-cli exiftool mediainfo
    bitwarden-cli gnupg age
    globalprotect-openconnect  # VPN client (official repo, stable)
)

# ── AUR-only packages (last resort) ──
# These are not in official repos / OPR.
# Install only after main packages succeed.
aur_packages=(
    carapace
    television
    herdr
    opencode
    pi                    # AI agent
    tuicr                 # TUI code review for git
    ai-usagebar-bin       # AI usage bar widget
    spotatui-bin          # Spotify TUI
    zoom                  # Video conferencing
)

# ── Install main repo packages ──
echo "==> Installing main repo packages (${#main_packages[@]})..."
if command -v omarchy &>/dev/null; then
    omarchy pkg add "${main_packages[@]}"
else
    sudo pacman -S --needed --noconfirm "${main_packages[@]}"
fi

echo ""
echo "==> Main repo packages done."

# ── Install AUR packages (last option) ──
echo ""
echo "==> Installing AUR packages (${#aur_packages[@]})..."
if command -v omarchy &>/dev/null; then
    # Omarchy can install AUR packages
    omarchy pkg aur add "${aur_packages[@]}" || true
elif command -v yay &>/dev/null; then
    yay -S --needed --noconfirm "${aur_packages[@]}" || true
elif command -v paru &>/dev/null; then
    paru -S --needed --noconfirm "${aur_packages[@]}" || true
else
    echo "WARNING: No AUR helper found (tried omarchy, yay, paru)."
    echo "Skipped AUR packages: ${aur_packages[*]}"
    echo "Install a helper (e.g. 'yay') and re-run this script."
fi

echo ""
echo "Done."
