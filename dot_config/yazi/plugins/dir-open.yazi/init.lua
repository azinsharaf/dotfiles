local get_cwd = ya.sync(function ()
	return tostring(cx.active.current.cwd)
end)

return {
	entry = function ()
		local cwd = get_cwd()
		local output, err = Command('explorer'):arg('.'):output()
		if err then
			return ya.notify({
				title = 'dir-open',
				content = 'Failed to run explorer, error.No : ' .. err,
				timeout = 1,
			})
		end
	end,
}
