local blink = require("blink.cmp")
blink.build():pwait()

blink.setup({
	-- keymaps
	keymap = {
		preset = "enter",
	},

	-- editor insert mode completions
	completion = {
		menu = {
			auto_show = true, -- show on type
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							return ctx.kind_icon
						end,
						highlight = function(ctx)
							return "BlinkCmpKind" .. ctx.kind
						end,
					},
				},
			},
		},
		documentation = {
			auto_show = false, -- show function signature/docs
		},
		ghost_text = {
			enabled = false,
			show_with_menu = false,
		},
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
	},

	-- cmdline completions
	cmdline = {
		enabled = true,
		keymap = { preset = "cmdline" },
		completion = {
			menu = { auto_show = true },
		},
	},

	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
		providers = {
			lsp = {
				opts = {
					tailwind_color_icon = "󱓻",
				},
			},
		},
	},

	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},
})
