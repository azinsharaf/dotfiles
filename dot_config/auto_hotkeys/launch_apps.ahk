#Requires AutoHotkey v2 64-bit

; ---------------------------------------------------------------------------
; App Launcher Hotkeys
; ---------------------------------------------------------------------------
;
; Primary bindings (Alt key):
;   !+Enter  -> Launch Zen browser
;   !Enter   -> Launch WezTerm terminal
; ---------------------------------------------------------------------------

; --- Alt key bindings ---
!+Enter:: {
    Run("zen.exe")
}

!Enter:: {
    ; Run hidden so wezterm.exe doesn't leave a blank console window
    ; beside the actual WezTerm GUI.
    Run("wezterm.exe", , "Hide")
}

; --- Win key alternatives (uncomment to use instead of Alt) ---
; #+Enter:: {
;     Run("zen.exe")
; }
;
; #Enter:: {
;     Run("wezterm.exe", , "Hide")
; }
