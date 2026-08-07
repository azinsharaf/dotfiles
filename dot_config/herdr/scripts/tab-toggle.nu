#!/usr/bin/env nu

def main [] {
    let state_path = ("~/.cache/herdr/tab-toggle.json" | path expand)
    let state_dir = ($state_path | path dirname)
    if not ($state_dir | path exists) {
        mkdir $state_dir
    }

    let snap = (herdr api snapshot | from json)
    let now = ($snap.result.snapshot.focused_tab_id?)

    if ($now | is-empty) {
        return
    }

    let last = (
        if ($state_path | path exists) {
            try { open $state_path | get last_tab_id? } catch { null }
        } else {
            null
        }
    )

    let last_still_exists = (
        if ($last == null) {
            false
        } else {
            try {
                herdr tab list
                | from json
                | get result.tabs
                | where tab_id == $last
                | is-not-empty
            } catch {
                false
            }
        }
    )

    if $last_still_exists and ($last != $now) {
        try { herdr tab focus $last }
    }

    { last_tab_id: $now } | to json | save --force $state_path
}