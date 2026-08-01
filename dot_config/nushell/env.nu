# env.nu
# Nushell environment variables - loaded once at startup.
# Cross-platform via chezmoi templating.

# Locale
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# Default applications
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Less: pass through colors, no init message, quit if one screen
$env.LESS = "-R -F -X"

# Colors
$env.NU_LOG_LEVEL = "Error"

# XDG / config dirs (Unix conventions; harmless on Windows)
$env.XDG_CONFIG_HOME = ($env.HOME? | default $env.USERPROFILE | path join ".config")
$env.XDG_CACHE_HOME  = ($env.HOME? | default $env.USERPROFILE | path join ".cache")
$env.XDG_DATA_HOME   = ($env.HOME? | default $env.USERPROFILE | path join ".local" "share")
$env.XDG_STATE_HOME  = ($env.HOME? | default $env.USERPROFILE | path join ".local" "state")

# Starship prompt binary
$env.STARSHIP_SHELL = "nu"

# Home / user (chezmoi homeDir works across darwin/linux/windows)
$env.HOME = "C:/Users/azin"

# Carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
