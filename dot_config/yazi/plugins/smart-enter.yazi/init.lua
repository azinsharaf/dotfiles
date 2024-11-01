function entry()
	local h = cx.active.current.hovered
	ya.manager_emit(h and h.cha.is_dir and "enter" or "open", {hovered = true})
end

return {entry = entry}
-- ya.manager_emit("cmd", args) : send a command to [manager]
