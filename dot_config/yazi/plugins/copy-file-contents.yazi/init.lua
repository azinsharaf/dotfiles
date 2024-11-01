local selected_files = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function notify(str)
	ya.notify({
		title = "Copy-file-contents",
		content = str,
		timeout = 3,
		level = "info",
	})
end

local function entry()
	-- Copy the contents of selected files into clipboard
	local files = selected_files()
	local contents = ''
	if #files == 0 then
		return
	else
		for _, file in pairs(files) do
			contents = file .. ' ' .. contents
		end
	end

	local cmd_args = "type " .. contents .. " | " .. 'clip'
	local shell_value = 'cmd'

	-- Spawn the command to copy the file contents to clipboard
	local output, err = Command(shell_value):args({ "/c", cmd_args }):spawn():wait()

	if not output then
		return ya.err("Cannot spawn clipboard command, error code " .. tostring(err))
	end

	-- Notify the user that the file contents have been copied to clipboard
	notify("Copied file contents to clipboard")
end

return {
	entry = entry,
}
