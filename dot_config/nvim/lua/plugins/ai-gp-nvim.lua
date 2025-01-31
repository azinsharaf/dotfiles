return {
	"robitx/gp.nvim",
	enabled = false,
	config = function()
		local conf = {
			-- For customization, refer to Install > Configuration in the Documentation/Readme
		}
		require("gp").setup(conf)

		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
		openai_api_key = os.getenv("OPENAI_API_KEY")
	end,
}
