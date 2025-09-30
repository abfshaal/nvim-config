return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  branch = "regexp",
  config = function()
    require("venv-selector").setup({
      search = {
        anaconda = {
          command = "fd /python$ /opt/homebrew/anaconda3/envs --full-path --color never",
          type = "anaconda"
        }
      },
      auto_refresh = true,
    })
  end,
  event = "VeryLazy",
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>" },
    { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
  },
}