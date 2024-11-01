local get_cwd = ya.sync(function (state) --  to make async function
	local h = cx.active.current.cwd
	return tostring(h)
end)

local entry = function ()
	local curdir = get_cwd()
	local value, event = ya.input({
		title = "Make xlsx/pptx",
		position = {"top-center", y = 3, w = 40},
	})
	if event ~= 1 then
		return
	end

	-- local ext = value:match('%.(%w+)') -- get extension
	local ext = value
	if ext == 'excel' then
		local status, err = Command('NewFile.cmd'):arg('excel'):spawn():wait()
	elseif ext == 'ppt' then
		local status, err = Command('NewFile.cmd'):arg('ppt'):spawn():wait()
	else
		ya.notify({
			title = 'Make xlsx/pptx',
			content = 'Extension must be .xlsx or .pptx',
			timeout = 1,
			level = 'info',
		})
	end
end


return {entry = entry}
