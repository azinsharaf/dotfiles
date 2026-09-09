-- Selectively restore Omarchy default binding modules we want to keep.
-- (media, clipboard, utilities, and applications were disabled by
-- omarchy_default_bindings = false in hyprland.lua)
require("default.hypr.bindings.media")
require("default.hypr.bindings.clipboard")
require("default.hypr.bindings.utilities")
require("default.hypr.bindings.applications")
require("default.hypr.bindings.voxtype")

-- ============================================
-- Vim-style window focus (h/j/k/l)
-- ============================================

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- ============================================
-- Vim-style window swap (Shift + h/j/k/l)
-- ============================================

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- ============================================
-- Window management basics
-- ============================================

o.bind("SUPER + W", "Close window", hl.dsp.window.close())
o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")
o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + P", "Pseudo window", hl.dsp.window.pseudo())
o.bind("SUPER + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

-- ============================================
-- Tiling layout controls
-- ============================================

o.bind("SUPER + code:47", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + code:48", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + Home", "Save window width", "omarchy-hyprland-window-width save")
o.bind("SUPER + Home", "Restore window width", "omarchy-hyprland-window-width restore")

-- ============================================
-- Workspace switching (1-10)
-- ============================================

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

o.bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + CTRL + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous" }))

-- ============================================
-- Monitor workspace movement
-- ============================================

o.bind("SUPER + SHIFT + ALT + LEFT", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + UP", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + DOWN", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

-- ============================================
-- Window cycling (Alt+Tab style)
-- ============================================

o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

o.bind("CTRL + ALT + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("CTRL + ALT + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

-- ============================================
-- Window resizing with -/= keys
-- ============================================

o.bind("SUPER + code:20", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + code:21", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + code:20", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + SHIFT + code:21", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

o.bind("SUPER + ALT + code:20", "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
o.bind("SUPER + ALT + code:21", "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:20", "Shrink window up a little", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:21", "Expand window down a little", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

o.bind("SUPER + CTRL + code:20", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
o.bind("SUPER + CTRL + code:21", "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:20", "Shrink window up a lot", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:21", "Expand window down a lot", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))

-- ============================================
-- Scratchpad
-- ============================================

o.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- ============================================
-- Mouse bindings
-- ============================================

o.bind("SUPER + mouse_down", "Scroll active workspace forward", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + mouse_up", "Scroll active workspace backward", hl.dsp.focus({ workspace = "e-1" }))

o.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
o.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

-- ============================================
-- Window grouping
-- ============================================

o.bind("SUPER + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("SUPER + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))

o.bind("SUPER + ALT + LEFT", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + RIGHT", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + UP", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + DOWN", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

o.bind("SUPER + ALT + TAB", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())

o.bind("SUPER + CTRL + LEFT", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("SUPER + CTRL + RIGHT", "Move grouped window focus right", hl.dsp.group.next())

o.bind("SUPER + ALT + mouse_down", "Next window in group", hl.dsp.group.next())
o.bind("SUPER + ALT + mouse_up", "Previous window in group", hl.dsp.group.prev())

for index = 1, 5 do
  o.bind("SUPER + ALT + code:" .. tostring(index + 9), "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
end

-- ============================================
-- Monitor scaling
-- ============================================

o.bind("SUPER + code:61", "Monitor scaling up", "omarchy-hyprland-monitor-scaling up")
o.bind("SUPER + ALT + code:61", "Monitor scaling down", "omarchy-hyprland-monitor-scaling down")

--- minimize wibdow
o.bind("SUPER + M", "Minimize window", hl.dsp.window.move({
  workspace = "special:omarchy-minimized",
  follow = false,
}))
