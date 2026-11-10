$dir = zoxide query -l | fzf
if ($dir) {
    tuios switch-session --create --cwd $dir (Split-Path $dir -Leaf)
}
