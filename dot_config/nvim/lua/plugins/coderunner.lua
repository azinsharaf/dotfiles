return {
  "CRAG666/code_runner.nvim",
  enabled = true,
  event = "VeryLazy",
  init = function() require("which-key").register({ ["<leader>r"] = { name = "Code Runner" } }, { mode = "n" }) end,
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
      python = "C:/Users/asharaf/AppData/Local/ESRI/conda/envs/arcgispro-py3-clone/python.exe"
      -- python = "C:/Python27/ArcGIS10.8/python.exe"
    },
  },
  keys = {
    { "<leader>rr", "<cmd>RunCode<cr>",    desc = "Run Code" },
    { "<leader>rf", "<cmd>RunFile<cr>",    desc = "Run File" },
    -- { "<leader>rft", "<cmd>RunFile tab<cr>", desc = "Run File Tab" },
    { "<leader>rp", "<cmd>RunProject<cr>", desc = "Run Project" },
    { "<leader>rc", "<cmd>RunClose<cr>",   desc = "Run Close" },
    -- { "<leader>crf", "<cmd>CRFiletype<cr>", desc = "Open Json supported files" },
    -- { "<leader>crp", "<cmd>CRProject<cr>", desc = "Open Json list of projects" },
  },
}
