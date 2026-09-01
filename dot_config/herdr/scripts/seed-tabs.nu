#!/usr/bin/env nu

source ~/.config/herdr/scripts/default-tabs.nu

def main [workspace_id: string] {
    for tab in (tabs) {
        let resp = (
            herdr tab create
                --workspace $workspace_id
                --label $tab.name
                --no-focus
            | from json
        )

        if ($tab.command? | is-not-empty) {
            let pane_id = ($resp | get result.root_pane.pane_id)
            herdr pane run $pane_id $tab.command
        }
    }
}
