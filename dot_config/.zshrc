# --- General Settings ---
setopt autocd             # Change directories without typing 'cd'
setopt extendedglob       # Enable advanced globbing
setopt histignoredups     # Ignore duplicate commands in history
setopt histfindnodups     # Ignore duplicates during search
setopt sharehistory       # Share command history across all sessions
setopt autocontinue       # Continue long commands over multiple lines

# --- Paths ---
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"
export EDITOR="nvim"       # Set default editor to Neovim
export PAGER="less"        # Use 'less' for paging

# --- Starship Prompt ---
# Ensure Starship is installed via Homebrew: `brew install starship`
# Configure Starship with a custom configuration file if needed.
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# --- History Settings ---
HISTFILE=~/.zsh_history      # History file location
HISTSIZE=5000                # Number of history entries
SAVEHIST=5000                # Saved entries

# --- Aliases ---
alias ls="ls -G"                  # Colorized 'ls'
alias ll="ls -lG"                 # Long listing
alias la="ls -laG"                # Show hidden files
alias n="nvim"                    # Short alias for Neovim
alias update="brew update && brew upgrade && brew cleanup"  # Update system
alias gs="git status"             # Git status shortcut
alias gd="git diff"               # Git diff shortcut

# --- Functions ---
f() {
  open .  # Open Finder from current terminal directory
}

mkcd() {
  mkdir -p "$1" && cd "$1"  # Quickly create and navigate to a new directory
}

# --- Plugins / Features ---
# Syntax highlighting (install with Homebrew: `brew install zsh-syntax-highlighting`)
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autocomplete (install with Homebrew: `brew install zsh-autosuggestions`)
if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- MacOS Specific ---
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
alias show_hidden="defaults write com.apple.Finder AppleShowAllFiles true; killall Finder"
alias hide_hidden="defaults write com.apple.Finder AppleShowAllFiles false; killall Finder"

# --- Completion ---
autoload -Uz compinit
compinit

# --- Key Bindings ---
bindkey -e
bindkey "^[[H" beginning-of-line    # Home key
bindkey "^[[F" end-of-line          # End key
bindkey "^[[3~" delete-char         # Delete key

# --- Performance ---
if [ -n "$TMUX" ]; then
  export TERM="screen-256color"
else
  export TERM="xterm-256color"
fi

# --- Source Local Config ---
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

