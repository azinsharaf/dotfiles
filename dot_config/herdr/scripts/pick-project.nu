#!/usr/bin/env nu

let PROJECTS_DIR = ("~/repos" | path expand)
let SEED_SCRIPT  = ("~/.config/herdr/scripts/seed-tabs.nu" | path expand)

let candidates = (
    ls $PROJECTS_DIR
    | where type == dir
    | get name
    | path basename
    | sort
)

if ($candidates | is-empty) {
    print "No projects found in ~/repos"
    exit 1
}

let pick = ($candidates | str join "\n" | ^fzf --prompt "project> " --height 20)
if ($pick | is-empty) { exit 0 }

let cwd = ([$PROJECTS_DIR $pick] | path join)

let existing = (
    herdr workspace list
    | from json
    | get result.workspaces
    | where label == $pick
)

if ($existing | is-empty) {
    print $"Creating workspace for ($pick)..."

    let resp = (
        herdr workspace create --cwd $cwd --label $pick --no-focus
        | from json
    )

    let workspace_id   = ($resp | get result.workspace.workspace_id)
    let initial_tab_id = ($resp | get result.tab.tab_id)

    nu $SEED_SCRIPT $workspace_id

    herdr tab close $initial_tab_id | ignore
    herdr workspace focus $workspace_id | ignore
} else {
    print $"Focusing existing workspace ($pick)..."
    let workspace_id = ($existing | get id | first)
    herdr workspace focus $workspace_id | ignore
}
