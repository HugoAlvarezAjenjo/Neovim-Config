local map = LazyVim.safe_keymap_set

-- Neotree
map("n", "<C-n>", "<cmd>Neotree toggle=true<CR>", {})

-- Terminal
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", {})
vim.keymap.set("n", "<leader>tg", "<cmd>ToggleTerm<CR>", {})
map("t", "<esc><esc>", "<cmd>ToggleTerm direction=float<CR>", {})
