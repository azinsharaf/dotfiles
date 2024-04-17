return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			-- The default keymap is <leader>o
			enable_chat = true,
			tools = {
				curl = "C:/Users/asharaf/AppData/Local/Microsoft/WinGet/Packages/cURL.cURL_Microsoft.Winget.Source_8wekyb3d8bbwe/curl-8.7.1_6-win64-mingw/bin/curl.exe",
				gzip = "C:/Program Files (x86)/GnuWin32/bin/gzip.exe",
			},
		})
	end,
}
