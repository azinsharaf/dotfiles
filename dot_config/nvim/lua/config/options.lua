vim.cmd("let g:netrw_lifestyle = 3")

local opt = vim.opt
local is_windows = vim.loop.os_uname().sysname:match("Windows")

if is_windows then
	-- PowerShell options for Windows
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}

	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
else
	-- Default shell options for macOS (or Linux)
	vim.opt.shell = "/bin/zsh"
	vim.opt.shellcmdflag = "-c"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

-- Tab / Indentation
opt.tabstop = 4       -- 4 spaces for tabs
opt.shiftwidth = 4    --4 spaces for indent width
opt.softtabstop = 4
opt.expandtab = true  -- expand tab to spaces
opt.smartindent = true
opt.autoindent = true -- copy indent from current line when starting new
opt.wrap = true
opt.linebreak = true  -- linebreak soft wrap at words

-- Search
opt.incsearch = true
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = false

-- Appearance
opt.number = true -- show the absolute number
opt.relativenumber = true
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.colorcolumn = "79"
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true -- highlight current line

-- Behavior
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
-- opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true -- split vertial window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.autochdir = false
opt.mouse:append("a")
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.modifiable = true
-- opt.guicursor = ""
opt.encoding = "UTF-8"
opt.showmode = true
opt.updatetime = 50

opt.wildignorecase = true
opt.wildmenu = true

opt.spell = false

-- Avante plugin: views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Set global conceallevel
opt.conceallevel = 0

-- Auto commands for specific file types
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "nvc"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.conceallevel = 1
	end,
})

-- auto-session plugin
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
