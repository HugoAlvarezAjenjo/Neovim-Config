return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"jdtls",
					"lemminx",
                    "clangd",
                    "texlab",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({}) -- Lua LSP
			lspconfig.jdtls.setup({}) -- Java LSP
			lspconfig.lemminx.setup({}) -- XML LSP
			lspconfig.clangd.setup({}) -- C/C++ LSP
			lspconfig.texlab.setup({}) -- TexLab LSP
		end,
	},
    { -- Utility for Configuring Java Language Server
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },
}
