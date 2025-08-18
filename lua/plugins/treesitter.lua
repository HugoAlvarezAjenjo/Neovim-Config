return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag", -- Auto-close tags
      "nvim-treesitter/nvim-treesitter-textobjects", -- Advanced text objects
    },
    cmd = { "TSUpdate", "TSInstall" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Essential features
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },

        -- Extended features
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true, -- New recommended setup method
    ft = { "html", "javascript", "typescript", "jsx", "tsx", "markdown" },
  },
}
