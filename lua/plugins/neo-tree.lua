return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Optional (for file icons)
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree", -- Lazy-load on command
  keys = { -- Lazy-load on these keymaps
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- Close if Neo-Tree is last window
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        git_status = {
          symbols = {
            -- Change git status symbols
            added     = "",
            modified = "",
            deleted  = "",
          }
        },
      },
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<cr>"] = "open",
          ["l"] = "open",  -- Expand folder or open file
          ["h"] = "close_node", -- Collapse folder
          ["<bs>"] = "navigate_up", -- Go to parent directory
        },
      },
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files by default
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true, -- Auto-reveal current file in tree
        },
        use_libuv_file_watcher = true, -- Better file watching
      },
      event_handlers = {
        -- Auto-close on file open
        {
          event = "file_opened",
          handler = function()
            require("neo-tree").close_all()
          end
        },
      }
    })

    -- Auto-open when directory is detected (optional)
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          require("neo-tree").show()
        end
      end
    })
  end,
}
