require("noice").setup({
	cmdline = { enabled = true, view = "cmdline_popup" },
	messages = { enabled = false },
	popupmenu = { enabled = false }, -- Blink anchors its completion menu to the Noice cmdline.
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
