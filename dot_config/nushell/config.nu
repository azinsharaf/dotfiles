# config.nu
# Minimal Nushell configuration.

$env.config.show_banner = false
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_COMMAND = { || starship prompt }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""

# Aliases
alias ll     = eza -lh
alias la     = eza -lha
alias lt     = eza --tree
alias cat    = bat
alias n      = nvim
alias lg     = lazygit
alias y      = yazi
alias ":q"   = exit
alias e      = exit
alias c      = clear
alias su     = scoop update
alias ss     = scoop status
alias sua    = scoop update --all
alias cedit  = chezmoi edit
alias cdiff  = chezmoi diff
alias cstatus = chezmoi status
alias capply = chezmoi apply --interactive -v
alias ccd    = chezmoi cd

use conda.nu *

source ~/.config/nushell/scripts/carapace.nu

# zoxide (smarter cd; registers `z` and `zi` aliases).
# Regenerate scripts/zoxide_init.nu with `zoxide init nushell` after
# updating zoxide, then `chezmoi add --force` and `chezmoi apply`.
source ~/.config/nushell/scripts/zoxide_init.nu

# load pi script
source ~/.config/nushell/pi.nu

# PATH
let h = $env.HOME

# Prepended (high priority)
$env.path = (
    [
        ($h | path join "scoop" "shims")
    ]
    | append $env.path
)

# Appended
$env.path ++= [
    ($h | path join ".cargo" "bin"),
    ($h | path join ".local" "bin"),
    'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI',
    ($h | path join "AppData" "Local" "pnpm"),
    ($h | path join "go" "bin"),
    ($h | path join "scoop" "apps" "perl" "current" "perl" "bin"),
    ($h | path join "scoop" "apps" "git" "current" "usr" "bin"),
    ($h | path join "scoop" "apps" "nodejs-nightly" "current" "bin"),
]

