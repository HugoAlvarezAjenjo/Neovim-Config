return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- List of desired sources (without availability checks)
    local desired_sources = {
      formatting.stylua,
      formatting.prettier.with({
        extra_args = { "--single-quote", "--jsx-single-quote" },
      }),
      formatting.google_java_format,
      diagnostics.erb_lint,
      diagnostics.rubocop,
      formatting.rubocop,
    }

    -- Filter sources based on executable availability
    local sources = {}
    for _, source in ipairs(desired_sources) do
      local command = source._opts and source._opts.command or source.command
      if vim.fn.executable(command) == 1 then
        table.insert(sources, source)
      else
        vim.notify_once("[null-ls] Not found: " .. command, vim.log.levels.WARN)
      end
    end

    null_ls.setup({
      debug = false,
      sources = sources,
      on_attach = function(client)
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "[C]ode [F]ormat" })
        end
      end,
    })
  end,
}
