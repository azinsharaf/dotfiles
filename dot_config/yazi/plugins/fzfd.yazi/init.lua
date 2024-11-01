local state = ya.sync(function()
	return cx.active.current.cwd
end)

local function fail(s, ...)
	ya.notify { title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function entry()
	local _permit = ya.hide()
	local cwd = tostring(state())

	local child_fd, err_fd =
		Command("fd")
		:cwd(cwd)
		:args({'--hidden'})
		:args({'--type', 'directory' , '.'})
		:stdin(Command.INHERIT)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	local child_fzf, err_fzf =
		Command('fzf')
		:stdin(child_fd:take_stdout())
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child_fd then
		return fail("Spawn `fd` failed with error code %s. Do you have it installed?", err_fd)
	elseif not child_fzf then
		return fail("Spawn `fzf` failed with error code %s. Do you have it installed?", err_fzf)
	end

	local output, err = child_fzf:wait_with_output()
	if not output then
		return fail("Cannot read `fzf` output, error code %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`fzf` exited with error code %s", output.status.code)
	end

	local target = output.stdout:gsub("\n$", "")
	if target ~= "" then
		ya.manager_emit(target:find("[/\\]$") and "cd" or "reveal", { target })
	end
end

return { entry = entry }
