return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "^.git/",        -- Improved git ignore pattern
            "^target/",       -- Rust/Java builds
            "%.class$",       -- Java classes
          },
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<Esc>"] = require("telescope.actions").close,
            },
          },
          layout_strategy = "horizontal",
          winblend = 10,      -- Slight transparency
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              layout_config = {
                width = 0.8,
                height = 0.7,
              },
            }),
          },
        },
      })

      -- Load UI-select extension
      require("telescope").load_extension("ui-select")

      -- Your original keymaps (unchanged)
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-o>", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<C-p>", builtin.commands, { desc = "Commands" })
      vim.keymap.set("n", "<C-i>", builtin.live_grep, { desc = "Live Grep" })
    end,
  },
}
