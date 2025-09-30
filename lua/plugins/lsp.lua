return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        pylsp = { enabled = false },
      },
    },
  },
}
