local function info(content)
	return ya.notify {
		title = "Nvim",
		content = content,
		timeout = 2,
		level = 'error',
	}
end

local hovered_url = ya.sync(function()
	return tostring(cx.active.current.hovered.url)
end)

return {
	entry = function()
		local path = hovered_url()
		if not path then
			info('Nvim Error : There is no hovered file')
			return
		end

		local _permit = ya.hide()
		-- use INHERIT as stdin/stdout/stderr for interactive app like nvim
		local status, err = Command("nvim")
						 	:arg(path)
							:stdin(Command.INHERIT)
							:stdout(Command.INHERIT)
							:stderr(Command.INHERIT)
							:spawn():wait()
		if not status then
			return info("Nvim Error : Failed to run nvim (code : " .. err .. ")")
		end
		_permit:drop()
	end,
}
