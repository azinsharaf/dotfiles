#Requires AutoHotkey v2 64-bit

; toggle Bluetooth on/off
F4:: {
    Send "#a"
    Sleep 200

    Send "{Tab}"
    Sleep 80

    Send "{Right}"
    Sleep 80

    Send "{Space}"
    Sleep 100

    Send "{Esc}"
}