-- The upstream tabufline loader reads a compiled tbline file when it starts.
local cache_dir = vim.fn.tempname()
vim.fn.mkdir(cache_dir, "p")
vim.g.base46_cache = cache_dir .. "/"

local base46 = require("base46")
local statusline_style = require("nvconfig").ui.statusline.theme
local function apply_highlights()
	-- These modules derive their colors from the active colorscheme on load.
	for _, name in ipairs({
		"themes.kien",
		"base46.integrations.tbline",
		"base46.integrations.statusline",
		"base46.integrations.statusline." .. statusline_style,
	}) do
		package.loaded[name] = nil
	end

	local tabufline = base46.get_integration("tbline")
	for _, integration in ipairs({ tabufline, base46.get_integration("statusline") }) do
		for name, opts in pairs(integration) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end
	return tabufline
end

base46.str_to_cache("tbline", base46.tb_2str(apply_highlights()))
require("nvchad.tabufline.lazyload")

vim.o.statusline = ("%%!v:lua.require('nvchad.stl.%s')()"):format(statusline_style)
require("nvchad.stl.utils").autocmds()

local group = vim.api.nvim_create_augroup("KienNvChadUi", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	desc = "Refresh NvChad UI highlights from the active colorscheme",
	callback = function()
		apply_highlights()
	end,
})
