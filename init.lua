-- Speeds up Lua loading (Neovim 0.9+)
if vim.loader then pcall(vim.loader.enable) end

-- Bootstrap lazy.nvim
require("config.lazy").bootstrap()

-- Shell and base config
require("config.shell").setup() -- Terminal config
require("config.keymaps") -- Keymaps
require("config.options") -- Vim config
-- require("config.autocmd") -- enable when needed

-- Plugin manager
require("lazy").setup("plugins")

