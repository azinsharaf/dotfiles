-- get branch contents from status
local get_branch = ya.sync(function (state, status)
	local branch = status:match('On branch (%S+)')
	state.branch = branch and '  ' .. branch or ""
end)

-- get stash contents from status
local get_stash = ya.sync(function (state, status)
	local stash = status:match('Your stash currently has (%S+)')
	state.stash = stash and ' $' .. stash or ""
end)

-- get commit contents from status
local get_commit = ya.sync(function (state, status)
	local commit = status:match('onto (%S+)')
	state.commit = commit and ' @' .. commit or ""
end)

-- get staged contents from status
local get_staged = ya.sync(function (state, status)
	local result = status:match('Changes to be committed:%s*(.-)%s*\n\n')
	if result then
		local list = result:gsub("^[%s]*%b()[%s]*", "")

		local staged = 0
		for line in list:gmatch("[^\r\n]+") do
			if line:match("%S") then
				staged = staged + 1
			end
		end
		state.staged = " +" .. staged
	else
		state.staged = ""
	end
end)

-- get unstaged contents from status
local get_unstaged = ya.sync(function (state, status)
	local result = status:match('Changes not staged for commit:%s*(.-)%s*\n\n')
	if result then
		local list = result:gsub("^[%s]*%b()[\r\n]*", ""):gsub("^[%s]*%b()[\r\n]*", "")

		local unstaged = 0
		for line in list:gmatch("[^\r\n]+") do
			if line:match("%S") then
				unstaged = unstaged + 1
			end
		end
		state.unstaged = " *" .. unstaged
	else
		state.unstaged = ""
	end
end)

-- get untracked contents from status
local get_untracked = ya.sync(function (state, status)
	local result = status:match('Untracked files:%s*(.-)%s*\n\n')
	if result then
		local list = result:gsub("^[%s]*%b()[\r\n]*", "")

		local untracked = 0
		for line in list:gmatch("[^\r\n]+") do
			if line:match("%S") then
				untracked = untracked + 1
			end
		end
		state.untracked = " ?" .. untracked
	else
		state.untracked = ""
	end
end)

-- get behind_ahead contents from status
-- local get_behind_ahead = ya.sync(function (state, status)
-- 	local result_ahead, result_behind = status:match("have (%d+) and (%d+) different")
-- 	if result then
-- 		state.untracked = " ?" .. untracked
-- 	else
-- 		state.untracked = ""
-- 	end
--
-- end)

-- setup function to register Header
local setup = function(state, args)
	state.branch = ''
	state.stash = ''
	state.staged = ''
	state.unstaged = ''
	state.commit = ''
	state.untracked = ''

	-- githead main function
	function Header:githead()
		ya.render() -- it needs to erase branch fast out of git repo

		return ui.Line{ -- must not be nil, it branch is nil, header isn't shown
			ui.Span(state.branch):fg('bright magenta'),
			ui.Span(state.stash):fg('bright blue'),
			ui.Span(state.staged):fg('bright green'),
			ui.Span(state.unstaged):fg('red'),
			ui.Span(state.commit):fg('bright yellow'),
			ui.Span(state.untracked):fg('gray'),
		}
	end

	-- register githead() to Header process
	Header:children_add(Header.githead, 3000, Header.LEFT)
end



-- fetch contents whenever entities have some changes
-- it seems that once fetch, 
-- it must return any value
local fetch = function (self)
	-- in yazi.toml, fetch call at * and */ => it means when I enter in directory, 
	-- fetch first item with self.files[1].url each of them. 
	-- so fetch one folder and one file at the top of the list (entering or file changing)
	--
	-- setting branch is fast, but clearing branch is slower than it
	-- I think all files are fetched at first time entering
	-- it will be waste time to show correct branch name because if they have lots of files to fetch

	local cwd = self.files[1].url:parent() -- get cwd
	-- if return is done early, branch is changed too slowly

	-- if there are no --no-optional-locks options, command call permanently
	-- if `2>nul` is added, it works in terminal to delete stderr, 
	-- but it erase commit / staged lists in Commnad()
	local status, err = Command('git')
						:cwd(tostring(cwd))
						:args({'--no-optional-locks', '-c', 'core.quotePath='})
						:args({'status'})
						:args({'--ignore-submodules=dirty', '--branch', '--show-stash', '--ahead-behind'})
						:stdout(Command.PIPED)
						:output()
	if not status then
		status.stdout = ""
	end
	-- save branch name
	get_branch(status.stdout)
	get_stash(status.stdout)
	get_staged(status.stdout)
	get_unstaged(status.stdout)
	get_commit(status.stdout)
	get_untracked(status.stdout)
	return 3

end


return {setup = setup, fetch = fetch}
