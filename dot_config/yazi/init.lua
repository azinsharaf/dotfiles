-- ////////////////////////////////////////////////////////////////////////////
-- ////////// init file to set functions to use in configuration //////////////
-- ////////////////////////////////////////////////////////////////////////////


-- [manager] - linemode
-- show size and mtime together
function Linemode:size_and_mtime()
	local time = (self._file.cha.modified or 0) // 1 -- get file date
	time = time and os.date("%Y/%m/%d %H:%M:%S", time) or "" -- show date only when it has

	local size = self._file:size() -- get file size

	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or '-', time))
end

-- [manager] - Statusmode
-- show original path of symbolic link in the status line (for 'show_symlink' = false)
function Status:name()
	local h = self._tab.current.hovered
	local linked = ""
	if h.link_to ~= nil then
		linked = " 󰜴 " .. tostring(h.link_to)
		return ui.Line("  " .. h.name .. linked)
	else
		return ui.Line(" " .. h.name)
	end
end

-- [plugins] - yamb.yazi
require("yamb"):setup {
  -- Optional, the cli of fzf.
  cli = "fzf",
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  -- Optional, the path of bookmark file
  path = os.getenv("HOME") .. "\\.config\\Dotfiles\\yazi\\bookmark"
}


-- [plugins] - hide-preview.yazi
-- turn off preview default (at startup)
require('hide-preview'):entry()



-- [plugins] - githead.yazi
-- show git branch and stochastics right after heading
require('githead'):setup()



-- [plugins] - yazi-rs/git.yazi
-- show git status right after directory
require('git'):setup()
