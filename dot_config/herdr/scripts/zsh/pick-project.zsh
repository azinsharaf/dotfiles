#!/usr/bin/env zsh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"

# ── Tab layout (edit here) ─────────────────────────────────────────
TABS_JSON=$(cat <<'JSON'
[
  {"name":"1: NVIM/AI","command":"nvim","split":{"direction":"right","command":"pi"}},
  {"name":"2: GIT","command":"lazygit","split":{"direction":"right","command":"tuicr"}},
  {"name":"3: YAZI","command":"yazi"},
  {"name":"4: SQL","command":"sqlit-tui"},
  {"name":"5: BTOP","command":"btop"},
  {"name":"6: RSS","command":""},
  {"name":"7: MUSIC","command":""}
]
JSON
)

seed_tabs() {
    local ws_id="$1"
    echo "$TABS_JSON" | jq -c '.[]' | while read -r tab; do
        local tab_name tab_cmd split_dir split_cmd
        tab_name=$(echo "$tab" | jq -r '.name')
        tab_cmd=$(echo "$tab" | jq -r '.command // empty')
        split_dir=$(echo "$tab" | jq -r '.split.direction // empty')
        split_cmd=$(echo "$tab" | jq -r '.split.command // empty')

        local resp root_pane_id
        resp=$(herdr tab create --workspace "$ws_id" --label "$tab_name" --no-focus)
        root_pane_id=$(echo "$resp" | jq -r '.result.root_pane.pane_id')

        [[ -z "$tab_cmd" ]] || herdr pane run "$root_pane_id" "$tab_cmd" > /dev/null 2>&1

        if [[ -n "$split_dir" ]]; then
            local split_resp new_pane_id
            split_resp=$(herdr pane split --pane "$root_pane_id" --direction "$split_dir" --no-focus)
            new_pane_id=$(echo "$split_resp" | jq -r '.result.pane.pane_id')
            [[ -z "$split_cmd" ]] || herdr pane run "$new_pane_id" "$split_cmd" > /dev/null 2>&1
        fi
    done
}

# ── Project sources (edit here) ──────────────────────────────────
SOURCES=$(cat <<'EOF'
[
  {"name":"repos","path":"~/repos","entries":"children"},
  {"name":"chezmoi","path":"~/.local/share/chezmoi","entries":"self"},
  {"name":"Hydro Viewer 1.17","path":"~/arcgis-experience-builder-1.17/ArcGISExperienceBuilder_PROD/server/public/apps","entries":"self"},
  {"name":"Hydro Viewer 1.21","path":"~/arcgis-experience-builder-1.21/ArcGISExperienceBuilder_PROD/server/public/apps","entries":"self"},
  {"name":"Azin Notes Personal","path":"~/Azin_Notes_Personal","entries":"self"},
  {"name":"Azin Notes Work","path":"~/OneDrive - Wood Rodgers Inc/Azin_Notes_Work","entries":"self"}
]
EOF
)

# ── Build candidate list (label + cwd) as JSON ────────────────────
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

echo "$SOURCES" | jq -c '.[]' | while read -r src; do
    name=$(echo "$src" | jq -r '.name')
    proj_path=$(echo "$src" | jq -r '.path')
    entries=$(echo "$src" | jq -r '.entries')
    expanded_path="${proj_path/#\~/$HOME}"

    [[ -d "$expanded_path" ]] || continue

    if [[ "$entries" == "self" ]]; then
        printf '{"label":"%s","cwd":"%s"}\n' "$name" "$expanded_path" >> "$tmpfile"
    else
        for d in "$expanded_path"/*(/N); do
            dname=$(basename "$d")
            printf '{"label":"%s/%s","cwd":"%s"}\n' "$name" "$dname" "$d" >> "$tmpfile"
        done
    fi
done

candidates_json=$(jq -s '.' "$tmpfile")

if [[ "$candidates_json" == "[]" ]] || [[ -z "$candidates_json" ]]; then
    echo "No projects found" >&2
    exit 1
fi

# ── Pick ──────────────────────────────────────────────────────────
pick=$(echo "$candidates_json" | jq -r '.[].label' | sort | fzf --prompt "project> " --height 20)
[[ -n "$pick" ]] || exit 0

# ── Silence ALL output after fzf ────────────────────────────────
exec >/dev/null 2>&1

cwd=$(echo "$candidates_json" | jq -r --arg label "$pick" '.[] | select(.label == $label) | .cwd')

existing=$(herdr workspace list | jq --arg label "$pick" '.result.workspaces | map(select(.label == $label)) | length')

if [[ "$existing" -eq 0 ]]; then
    local resp workspace_id initial_tab_id
    resp=$(herdr workspace create --cwd "$cwd" --label "$pick" --no-focus)
    workspace_id=$(echo "$resp" | jq -r '.result.workspace.workspace_id')
    initial_tab_id=$(echo "$resp" | jq -r '.result.tab.tab_id')

    seed_tabs "$workspace_id"

    herdr tab close "$initial_tab_id" 2>/dev/null || true
    herdr workspace focus "$workspace_id" 2>/dev/null || true
else
    local workspace_id
    workspace_id=$(herdr workspace list | jq --arg label "$pick" '.result.workspaces | map(select(.label == $label)) | .[0].workspace_id')
    herdr workspace focus "$workspace_id" 2>/dev/null || true
fi
