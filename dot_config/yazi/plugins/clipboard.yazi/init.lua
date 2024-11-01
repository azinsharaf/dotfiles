-- get select files
---@return table paths selected items or a hovered item
local selected_or_hovered = ya.sync(function()
	local paths = {}

	-- get selected files
	for _, u in pairs(cx.active.selected) do
		paths[#paths + 1] = tostring(u)
	end

	-- if anything is selected, select hovered file
	if #paths == 0 and cx.active.current.hovered then
		paths[1] = tostring(cx.active.current.hovered.url)
	end
	return paths
end)


return {
	entry = function(_, args)
		local action = args[1]
		ya.manager_emit("escape", { visual = true })

		local urls = selected_or_hovered()

		-- if there are not files even if hovered, fire error
		if action == "copy" then
			-- get file list table

			-- if selected or hovered files doesn't exist, invoke fails
			if #urls == 0 then
				return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 2 })
			end

			-- copy command
			local status, err = Command("cb"):arg("copy"):args(urls):spawn():wait()
			if status or status.succes then
				ya.notify({
					title = "System Clipboard",
					content = "Succesfully copied the file(s) to system clipboard",
					level = "info",
					timeout = 1,
				})
			else
				ya.notify({
					title = "System Clipboard",
					content = string.format( "Could not copy selected file(s) %s",
											status and status.code or err),
					level = "error",
					timeout = 2,
				})
			end

		elseif action == "paste" then
			-- check clipboard has files or directories not text or image
			local child, err = Command("cb"):arg("info"):stdin(Command.INHERIT):stdout(Command.PIPED):spawn()
			local output, err2 = child:wait_with_output()
			-- FIXME: output how many files are pasted
			local ok = string.find(output.stdout, "files")

			if ok then
				-- overwrite even though there are same named files (by stderr(Command.PIPED))
				-- FIXME: if there are same files, it must pop up menu
				child, err = Command("cb"):arg("paste"):stderr(Command.PIPED):spawn()
				output, err = child:wait()


				if output or output.succes then
					ya.notify({
						title = 'system-clipboard',
						content = 'Pasted from Clipboard',
						level = 'info',
						timeout = 1,
					})
				else
					ya.notify({
						title = "System Clipboard",
						content = string.format( "Could not paste selected file(s) %s",
												output and output.code or err),
						level = "error",
						timeout = 2,
					})
				end

			end
		end


		-- disable selection and visual
		ya.manager_emit("escape", { visual = true, select = true })

	end,
}
