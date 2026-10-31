#!/usr/bin/env zsh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"

STATE_PATH="$HOME/.cache/herdr/tab-toggle.json"
mkdir -p "$(dirname "$STATE_PATH")"

NOW=$(herdr api snapshot | jq -r '.result.snapshot.focused_tab_id // empty')

if [[ -z "$NOW" ]]; then
    exit 0
fi

LAST=""
if [[ -f "$STATE_PATH" ]]; then
    LAST=$(jq -r '.last_tab_id // empty' "$STATE_PATH" 2>/dev/null)
fi

LAST_EXISTS=false
if [[ -n "$LAST" ]]; then
    EXISTS=$(herdr tab list | jq --arg last "$LAST" '.result.tabs | map(select(.tab_id == $last)) | length')
    if [[ "$EXISTS" -gt 0 ]]; then
        LAST_EXISTS=true
    fi
fi

if [[ "$LAST_EXISTS" == "true" && "$LAST" != "$NOW" ]]; then
    herdr tab focus "$LAST" > /dev/null 2>&1
fi

printf '{"last_tab_id":"%s"}\n' "$NOW" > "$STATE_PATH"
