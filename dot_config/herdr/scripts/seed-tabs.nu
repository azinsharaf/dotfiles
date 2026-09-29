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

        let root_pane_id = ($resp | get result.root_pane.pane_id)

        if ($tab.command? | is-not-empty) {
            herdr pane run $root_pane_id $tab.command
        }

        if ($tab.split? | is-not-empty) {
            let split_resp = (
                herdr pane split
                    --pane $root_pane_id
                    --direction $tab.split.direction
                    --no-focus
                | from json
            )
            let new_pane_id = ($split_resp | get result.pane.pane_id)
            if ($tab.split.command? | is-not-empty) {
                herdr pane run $new_pane_id $tab.split.command
            }
        }
    }
}
