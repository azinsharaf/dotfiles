return {
	"CRAG666/code_runner.nvim",
	enabled = true,
	event = "VeryLazy",
	opts = {
		mode = "float", --"toggle", "float", "tab", "toggleterm"
		focus = true,
		term = {
			position = "bot",
			size = 25,
		},
		float = {
			border = "single",
			height = 0.9,
			width = 0.6,
		},
		filetype = {
			python = "C:/Users/asharaf/AppData/Local/ESRI/conda/envs/arcgispro-py3-clone/python.exe",
			-- python = "C:/Python27/ArcGIS10.8/python.exe"
		},
	},
}
