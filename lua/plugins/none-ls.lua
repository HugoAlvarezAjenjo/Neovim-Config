return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		-- Silent availability check (no notifications)
		local function is_available(source)
			local cmd = type(source.command) == "table" and source.command.command
				or source._opts and source._opts.command
				or source.command
			return cmd and vim.fn.executable(cmd) == 1
		end

		-- Sources with silent filtering
		local sources = {}
		for _, source in ipairs({
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettier.with({
				extra_args = { "--single-quote", "--jsx-single-quote" },
			}),
			null_ls.builtins.formatting.google_java_format,
			null_ls.builtins.diagnostics.erb_lint,
			null_ls.builtins.diagnostics.rubocop,
			null_ls.builtins.formatting.rubocop,
		}) do
			if is_available(source) then
				table.insert(sources, source)
			end
		end

		null_ls.setup({
			sources = sources,
			on_attach = function(client)
				if client.server_capabilities.documentFormattingProvider then
					vim.keymap.set("n", "<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, { desc = "Format buffer" })
				end
			end,
		})
	end,
}
