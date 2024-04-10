return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", {}),
		vim.keymap.set("t", "<esc>", "<cmd>ToggleTerm direction=float<CR>", {}),
		vim.keymap.set("n", "<leader>tg", "<cmd>ToggleTerm<CR>", {}),
	},
}
