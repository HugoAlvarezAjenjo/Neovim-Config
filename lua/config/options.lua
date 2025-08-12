-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Behavior
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.fileencoding = "utf-8"
vim.opt.undofile = true
vim.opt.updatetime = 250

-- Filetype overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Toggle relativenumber dynamically
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  pattern = "*",
  callback = function() vim.opt.relativenumber = true end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  pattern = "*",
  callback = function() vim.opt.relativenumber = false end,
})
