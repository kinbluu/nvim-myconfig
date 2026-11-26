require("kien.configs")

-- UI2 is experimental in Neovim 0.12 (see :help ui2).
require("vim._core.ui2").enable({
	msg = {
		targets = "cmd",
		pager = { height = 0.5 },
		msg = { timeout = 4500 },
	},
})

require("kien.core")

vim.cmd.colorscheme("tokyonight")
