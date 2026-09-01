#!/usr/bin/env nu

let SEED_SCRIPT = ("~/.config/herdr/scripts/seed-tabs.nu" | path expand)

let SOURCES = [
    {
        name: "repos"
        path: ("~/repos" | path expand)
        entries: "children"
    }
    {
        name: "chezmoi"
        path: ("~/.local/share/chezmoi" | path expand)
        entries: "self"
    }
    {
        name: "Hydro Viewer"
        path: ("~/arcgis-experience-builder-1.17/ArcGISExperienceBuilder_PROD/server/public/apps" | path expand)
        entries: "self"
    }
]

let candidates = (
    $SOURCES
    | each { |src|
        if not ($src.path | path exists) {
            []
        } else if $src.entries == "self" {
            [ { label: $src.name, cwd: $src.path } ]
        } else {
            ls $src.path
            | where type == dir
            | get name
            | path basename
            | each { |d| { label: $"($src.name)/($d)", cwd: ([$src.path $d] | path join) } }
        }
    }
    | flatten
    | sort-by label
)

if ($candidates | is-empty) {
    print "No projects found"
    exit 1
}

let pick = (
    $candidates
    | get label
    | str join "\n"
    | ^fzf --prompt "project> " --height 20
)
if ($pick | is-empty) { exit 0 }

let chosen = ($candidates | where label == $pick | first)
let label = ($chosen | get label)
let cwd = ($chosen | get cwd)

let existing = (
    herdr workspace list
    | from json
    | get result.workspaces
    | where label == $label
)

if ($existing | is-empty) {
    print $"Creating workspace for ($label)..."

    let resp = (
        herdr workspace create --cwd $cwd --label $label --no-focus
        | from json
    )

    let workspace_id   = ($resp | get result.workspace.workspace_id)
    let initial_tab_id = ($resp | get result.tab.tab_id)

    nu $SEED_SCRIPT $workspace_id

    herdr tab close $initial_tab_id | ignore
    herdr workspace focus $workspace_id | ignore
} else {
    print $"Focusing existing workspace ($label)..."
    let workspace_id = ($existing | get workspace_id | first)
    herdr workspace focus $workspace_id | ignore
}
