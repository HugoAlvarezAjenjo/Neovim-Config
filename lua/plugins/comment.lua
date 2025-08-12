return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Keymaps with unique descriptions
      vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle line comment" })
      vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle block comment" })

      -- Lazy-load TSX context only for relevant filetypes
      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
      require("Comment").setup({
        pre_hook = function(ctx)
          -- Only activate TSX handling for JSX/TSX files
          if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
            return ts_context_commentstring.create_pre_hook()(ctx)
          end
        end,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "bg",           -- Highlight entire line
        pattern = [[.*<(KEYWORDS)\s*:]], -- Match `TODO:`, `FIXME:`, etc.
      },
      search = {
        command = "rg",           -- Use ripgrep for faster searches
      },
    },
    event = "BufRead",            -- Load only when opening files
  },
}
