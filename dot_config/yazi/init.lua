require("mime-ext.local"):setup({
	with_exts = {
		tcss = "text/css",
	},
	fallback_file1 = true,
})

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.PLAIN,
})

require("git"):setup()

require("no-status"):setup()

require("starship"):setup({
	-- Hide flags (such as filter, find and search). This is recommended for starship themes which
	-- are intended to go across the entire width of the terminal.
	hide_flags = false, -- Default: false
	-- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
	flags_after_prompt = true, -- Default: true
	-- Custom starship configuration file to use
	config_file = "~/.config/starship/starship.toml", -- Default: nil
})

require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode = "dir" },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = true,
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("spot"):setup({
	metadata_section = {
		enable = true,
		hash_cmd = "xxhsum", -- other hashing commands may be slower
		hash_filesize_limit = 150, -- in MB, set 0 to disable
		relative_time = true, -- 2026-01-01 or n days ago
		time_format = "%Y-%m-%d %H:%M", -- https://www.man7.org/linux/man-pages/man3/strftime.3.html
		show_compression = true, ---@type boolean
	},
	plugins_section = {
		enable = true,
	},
	style = {
		color = {
			metadata = true,
			title = "green",
			key = "reset",
			value = "blue",
			selected = "blue",
		},
		size = {
			height = 20, -- unused when auto_resize is set to true
			width = 60, -- unused when auto_resize is set to true
			auto_resize = true,
			min_width = 60,
			max_width = 80,
			min_height = 20,
			max_height = 40,
		},
		max_key_length = 25,
		key_indent_size = 2,
	},
})

-- to get the size and modified time for linemode
function Linemode:size_and_mtime()
	local mtime = math.floor(self._file.cha.mtime or 0)
	local time ---@type string
	if mtime == 0 then
		time = ""
	elseif os.date("%Y", mtime) == os.date("%Y") then
		time = os.date("%b %d %H:%M", mtime) --[[@as string]]
	else
		time = os.date("%b %d  %Y", mtime) --[[@as string]]
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
