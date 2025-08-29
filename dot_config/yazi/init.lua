require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.PLAIN,
})

require("git"):setup()

require("starship"):setup({
	-- Hide flags (such as filter, find and search). This is recommended for starship themes which
	-- are intended to go across the entire width of the terminal.
	hide_flags = false, -- Default: false
	-- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
	flags_after_prompt = true, -- Default: true
	-- Custom starship configuration file to use
	config_file = "~/.config/starship/starship.toml", -- Default: nil
})

-- to get the size and modified time for linemode
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
