-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remove search highlights
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Remove search highlights", silent = true })

-- Stay in visual mode on indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- --- Terminal ---
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", {desc = "Open floating terminal"})
vim.keymap.set("n", "<leader>tg", "<cmd>ToggleTerm<CR>", {desc = "Open terminal"})
vim.keymap.set("t", "<esc><esc>", "<cmd>ToggleTerm direction=float<CR>", {desc = "Exit Terminal Mode", silent = true})

-- --- Git Stuff ---
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", {desc = "Preview git hunk"})
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", {desc = "Toggle git blame"})
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", {desc = "Open LazyGit menu"})

-- --- Code Actions ---
vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "Show documentation"})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "Code Actions"})
vim.keymap.set("n", "<leader>cx", vim.lsp.buf.format, {desc = "Format code"})
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {desc = "Rename variable"})
vim.keymap.set("n", "<leader>fd", vim.lsp.buf.definition, {desc = "Go to definition"})
vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, {desc = "Go to references"})

-- --- Neotree ---
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle=true<CR>", {desc = "Toggle Neotree"})
vim.keymap.set("n", "<leader>n", ":Neotree buffers reveal float<CR>", {desc = "Toggle Neotree buffers"})
