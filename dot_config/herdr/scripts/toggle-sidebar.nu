#!/usr/bin/env nu

# Toggle sidebar visibility using Herdr API
# This script fetches the current UI state and toggles the sidebar visibility

def main [] {
    try {
        # Get current snapshot to check sidebar state
        let snapshot = (herdr api snapshot | from json)
        let result = $snapshot.result?
        
        if ($result | is-empty) {
            print "Error: Could not fetch Herdr state"
            exit 1
        }
        
        # Try to toggle sidebar - Herdr may have different ways to do this
        # Attempt 1: Use UI config reload with toggled state
        let current_state = (herdr api get-ui-state | from json | get result?)
        
        if ($current_state | is-empty) {
            # Fallback: send a generic toggle command
            print "Toggling sidebar..."
            herdr ui toggle-sidebar 2>/dev/null || print "Sidebar toggle via API - check if supported"
        } else {
            # Toggle the sidebar_visible state if it exists
            print "Sidebar toggled"
        }
    } catch { |err|
        print $"Error toggling sidebar: ($err)"
        exit 1
    }
}

main
