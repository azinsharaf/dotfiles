#Requires AutoHotkey v2 64-bit

; ---------------------------------------------------------------------------
; App Launcher Hotkeys
; ---------------------------------------------------------------------------
;
; Primary bindings (Win key):
;   #+Enter  -> Launch Zen browser
;   #Enter   -> Launch WezTerm terminal
;
; Alternative bindings (Left Alt) — uncomment the block below if the Win key
; combinations are intercepted by Windows or otherwise don't work:
;
;   !+Enter  -> Launch Zen browser
;   !Enter   -> Launch WezTerm terminal
; ---------------------------------------------------------------------------

; --- Win key bindings ---
#+Enter:: {
    Run("zen.exe")
}

#Enter:: {
    ; Run hidden so wezterm.exe doesn't leave a blank console window
    ; beside the actual WezTerm GUI.
    Run("wezterm.exe", , "Hide")
}

; --- Alt key alternatives (uncomment to use instead of Win) ---
; !+Enter:: {
;     Run("zen.exe")
; }
;
; !Enter:: {
;     Run("wezterm.exe")
; }
