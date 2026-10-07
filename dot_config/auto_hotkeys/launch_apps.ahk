#Requires AutoHotkey v2 64-bit

; alt + shift + enter

!+Enter:: {
    Run("zen.exe")
}

; alt + enter
!Enter:: {
    ; Run hidden so wezterm.exe doesn't leave a blank console window
    ; beside the actual WezTerm GUI.
    Run("wezterm.exe", , "Hide")
