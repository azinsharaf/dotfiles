local info = function (txt)
	ya.notify({
		title = 'echo-filename',
		content = txt,
		timeout = 2,
	})
end

return {
	entry = function ()
		local h = cx.active.current.hovered
		if h then
			info(h.url:name())
		else
			info('echo-filename.yazi Error : Not hovered')
		end
	end
}
