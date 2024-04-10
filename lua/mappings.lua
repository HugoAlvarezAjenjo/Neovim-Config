-- --- Git Stuff ---
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", {})
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", {})

-- --- Code Actions ---
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- --- Navigation Methods
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})

-- --- Neotree ---
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle=true<CR>", {})
vim.keymap.set("n", "<leader>n", ":Neotree buffers reveal float<CR>", {})

-- --- Terminal ---
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", {})
vim.keymap.set("n", "<leader>tg", "<cmd>ToggleTerm<CR>", {})
vim.keymap.set("t", "<esc>", "<cmd>ToggleTerm direction=float<CR>", {})
