-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set shell options depending on OS
local is_windows = vim.loop.os_uname().version:match("Windows")
if is_windows then
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
else
	-- Assume bash/zsh on Unix-like systems
	vim.opt.shell = vim.fn.executable("zsh") == 1 and "zsh" or "bash"
	vim.opt.shellcmdflag = "-c"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

-- Import config
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("lazy").setup("plugins")

