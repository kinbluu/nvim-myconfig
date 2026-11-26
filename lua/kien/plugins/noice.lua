require("noice").setup({
	-- UI2 owns the command line and messages. Blink handles completion.
	cmdline = { enabled = false },
	messages = { enabled = false },
	popupmenu = { enabled = false },
	lsp = {
		progress = { enabled = true },
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
		},
		signature = {
			auto_open = { enabled = false },
		},
		hover = {
			enabled = true,
			silent = true,
		},
	},
})
