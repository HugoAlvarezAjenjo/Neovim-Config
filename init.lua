-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Set powershell options
local powershell_options = {
	shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
	shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
	shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
	shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
	shellquote = "",
	shellxquote = "",
}

for option, value in pairs(powershell_options) do
	vim.opt[option] = value
end

-- Import config
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("lazy").setup("plugins")

