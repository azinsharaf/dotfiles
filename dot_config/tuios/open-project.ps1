$dir = zoxide query -l | fzf
if ($dir) {
    $name = Split-Path $dir -Leaf

    # If this runs inside tuios, switch the client that shows the current
    # session. Without this, tuios complains when more than one client is
    # attached: "several clients are attached, so the one to switch must be named."
    $session = $env:TUIOS_SESSION
    if (-not $session) {
        try {
            $info = tuios session-info --json | ConvertFrom-Json
            $session = $info.session_name
        } catch {
            $session = $null
        }
    }

    if ($session) {
        tuios switch-session --create --cwd "$dir" -s "$session" "$name"
    } else {
        tuios switch-session --create --cwd "$dir" "$name"
    }
}
