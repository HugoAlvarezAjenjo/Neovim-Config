return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,    -- Load immediately (not lazy-loaded)
  priority = 1000, -- Highest priority (load before other plugins)
  opts = {         -- Customize colors/flavors
    flavour = "mocha", -- latte, frappe, macchiato, mocha (darkest)
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      telescope = true,
      mason = true,
      -- Enable more integrations as needed:
      -- native_lsp = { enabled = true },
      -- barbar = true,
    },
    custom_highlights = function(colors)
      return {
        -- Example custom highlights:
        Comment = { fg = colors.surface2, italic = true },
        LineNr = { fg = colors.overlay1 },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin") -- Applies the flavor set in `opts`
  end,
}
