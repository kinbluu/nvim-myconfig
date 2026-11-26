require("showkeys").setup({
	maxkeys = 4,
	show_count = false,
	position = "bottom-center",

	keyformat = {
		["<BS>"] = "󰁮 ",
		["<CR>"] = "󰘌",
		["<Space>"] = "󱁐",
		["<Up>"] = "󰁝",
		["<Down>"] = "󰁅",
		["<Left>"] = "󰁍",
		["<Right>"] = "󰁔",
		["<PageUp>"] = "Page 󰁝",
		["<PageDown>"] = "Page 󰁅",
		["<M>"] = "Alt",
		["<C>"] = "Ctrl",
	},
})

require("showkeys").open()
