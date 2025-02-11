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
	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end

-- [plugins] - full-border
require("full-border"):setup()

-- [plugins] - git
require("git"):setup()

-- [plugin] - starsship
require("starship"):setup()

-- [plugin] relative motion
require("relative-motions"):setup({ show_numbers = "relative" })

-- [plugin] - status-line

require("yatline"):setup({
	show_background = false,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_path" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})

require("eza-preview"):setup({
	-- Determines the directory depth level to tree preview (default: 3)
	level = 3,

	-- Whether to follow symlinks when previewing directories (default: false)
	follow_symlinks = false,

	-- Whether to show target file info instead of symlink info (default: false)
	dereference = false,
})

-- -- Show user/group of files in status bar
-- Status:children_add(function()
-- 	local h = cx.active.current.hovered
-- 	if h == nil or ya.target_family() ~= "unix" then
-- 		return ui.Line({})
-- 	end
--
-- 	return ui.Line({
-- 		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
-- 		ui.Span(":"),
-- 		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
-- 		ui.Span(" "),
-- 	})
-- end, 500, Status.RIGHT)
