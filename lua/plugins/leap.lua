return {
  "ggandor/leap.nvim",
  dependencies = { "tpope/vim-repeat" },
  keys = {
    -- Basic leap motions
    { "S", "<Plug>(leap)", mode = { "n", "x", "o" }, desc = "Leap forward" },
    { "<leader>lS", "<Plug>(leap-from-window)", mode = "n", desc = "Leap across windows" },

    -- Remote operations
    {
      "<leader>lr",
      function()
        require("leap.remote").action()
      end,
      mode = { "n", "o" },
      desc = "Leap remote action",
    },

    -- Treesitter selection
    {
      "<leader>lt",
      function()
        require("leap.treesitter").select()
      end,
      mode = { "x", "o" },
      desc = "Leap treesitter select",
    },
  },
}
