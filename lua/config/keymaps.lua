-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local map = vim.keymap.set

map({ "t" }, "<Esc><Esc>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true))

map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "$")

-- Telescope mappings

map({ "n" }, "<leader>fw", "<cmd>Telescope live_grep <cr>")
map({ "n" }, "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <cr>")

map({ "v" }, "K", ":m '<-2<CR>gv=gv", { silent = true })
map({ "v" }, "J", ":m '>+1<CR>gv=gv", { silent = true })
map({ "n" }, "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { silent = true })
map(
  { "v" },
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { silent = true }
)

map({ "n" }, "<leader>tn", "<Cmd> tabnext<CR>", { silent = true, noremap = true })
map({ "n" }, "<leader>ft", "<Cmd>FloatermToggle --cmd='cd $(pwd)'<cr>", { noremap = true, silent = true })

map({ "n" }, "<leader>a", function()
  require("harpoon.mark").add_file()
end)
map({ "n" }, "<C-e>", function()
  require("harpoon.ui").toggle_quick_menu()
end)
map({ "n" }, "<C-f>", function()
  require("harpoon.ui").nav_file(1)
end)
map({ "n" }, "<C-t>", function()
  require("harpoon.ui").nav_file(2)
end)
map({ "n" }, "<C-n>", function()
  require("harpoon.ui").nav_file(3)
end)
map({ "n" }, "<C-g>", function()
  require("harpoon.ui").nav_file(4)
end)

map({ "n" }, "<leader>cn", "i# %%<Esc>o<Esc>x")
map({ "n" }, "<C-y>", "<cmd>call augment#Accept()<cr>")

map({ "n" }, "<leader>ghf", "<cmd>Gitsigns preview_hunk<cr>")
