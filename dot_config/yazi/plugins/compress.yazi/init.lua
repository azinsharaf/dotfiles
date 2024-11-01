-- get selected files list with ' ' separator
local get_selected = ya.sync(function ()
	local select = cx.active.selected
	local paths_tb = {}
	for _, path in pairs(select) do
		paths_tb[#paths_tb+1] = tostring(path)
	end
	return paths_tb
end)

-- append list of table to string
-- local dump_table = ya.sync(function (state, tb)
-- 	local dump_tb = ''
-- 	for key, value in ipairs(tb) do
-- 		dump_tb = value .. '\n' .. dump_tb
-- 	end
-- 	return dump_tb
-- end)


return {
	entry = function ()
		local plugin_name = 'Zip with 7z'

		-- input for archive file name
		local archive_name, event = ya.input({
			title = plugin_name,
			position = {'top-center', w = 50},
		})

		if 		event == 0 then ya.notify({ title = plugin_name, content = 'Faile to zip', timeout = 1, })
		elseif 	event == 2 then return
		end

		-- archive file using bandizip
		local files = {}
		files = get_selected()
		local output, err = Command('bandizip')
							:arg('c')
							:arg('-fmt:7z')
							:arg(archive_name .. '.7z')
							:args(files)
							:output()
		if err then
			ya.notify({
				title = 'compress',
				content = 'Failed to run explorer, error.No : ' .. err,
				timeout = 2,
			})
		end

		-- clear selection
		ya.manager_emit('escape', {visual = true, select = true})
	end
}
