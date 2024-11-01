local function info(content)
	return ya.notify {
		title = "Diff",
		content = content,
		timeout = 2,
		level = 'error',
	}
end

local selected_url = ya.sync(function()
	local paths = {}

	-- check selected path
	for _, u in pairs(cx.active.selected) do
		paths[#paths + 1] = tostring(u)
	end

	-- check rationality
	if #paths == 1 then
		paths[#paths + 1] = tostring(cx.active.current.hovered.url)
		return paths
	elseif #paths == 2 then
		return paths
	else
		return nil
	end
end)

return {
	entry = function()
		local paths = selected_url()
		if not paths then
			info('Diff Error : select two files')
			return
		end

		local _permit = ya.hide()
		-- use INHERIT as stdin/stdout/stderr for interactive app like nvim
		local status, err = Command("nvim"):arg("-d")
						 	:arg(paths[1]):arg(paths[2])
							:stdin(Command.INHERIT)
							:stdout(Command.INHERIT)
							:stderr(Command.INHERIT)
							:spawn():wait()
		if not status then
			return info("Diff Error : Failed to run diff (code : " .. err .. ")")
		end
		_permit:drop()
		ya.manager_emit('escape', {visual = true, select = true})
	end,
}
