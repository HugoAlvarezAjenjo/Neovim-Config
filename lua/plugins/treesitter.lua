return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Additional text objects
      "windwp/nvim-ts-autotag", -- Auto-close HTML tags
    },
    cmd = { "TSUpdate", "TSInstall", "TSEnable" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Essential
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false, -- Faster parsing
        },
        indent = {
          enable = true,
          disable = { "python", "yaml" }, -- Languages where indentation is problematic
        },

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
        autotag = {
          enable = true,
          filetypes = { "html", "javascript", "typescript", "jsx", "tsx", "markdown" },
        },
        ensure_installed = { -- Recommended core languages
          "lua",
          "vim",
          "vimdoc",
          "query",
          "bash",
          "markdown",
          "markdown_inline",
          "python",
          "javascript",
          "typescript",
          "html",
          "css",
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = true, -- Simple setup
    ft = { "html", "jsx", "tsx", "markdown" }, -- Only load for relevant files
  },
}
