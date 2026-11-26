-- The upstream tabufline loader reads a compiled tbline file when it starts.
local cache_dir = vim.fn.tempname()
vim.fn.mkdir(cache_dir, "p")
vim.g.base46_cache = cache_dir .. "/"

local base46 = require("base46")
local config = require("nvconfig")
local function apply_highlights()
	-- These modules derive their colors from the active colorscheme on load.
	for _, name in ipairs({
		"themes.kien",
		"base46.integrations.tbline",
		"base46.integrations.statusline",
		"base46.integrations.statusline." .. config.ui.statusline.theme,
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

local function set_statusline()
	local theme = config.ui.statusline.theme
	vim.o.statusline = ("%%!v:lua.require('nvchad.stl.%s')()"):format(theme)
end

set_statusline()
require("nvchad.stl.utils").autocmds()

local group = vim.api.nvim_create_augroup("KienNvChadUi", { clear = true })
local chadrc_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua/chadrc.lua")
vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	pattern = "chadrc.lua",
	desc = "Reload the NvChad statusline after saving chadrc.lua",
	callback = function(args)
		local path = vim.uv.fs_realpath(chadrc_path)
		if not path or vim.uv.fs_realpath(vim.api.nvim_buf_get_name(args.buf)) ~= path then
			return
		end

		local old_chadrc = package.loaded.chadrc
		package.loaded.chadrc = nil
		local ok, updated = pcall(require, "chadrc")
		if not ok or type(updated) ~= "table" then
			package.loaded.chadrc = old_chadrc
			vim.notify(ok and "chadrc.lua must return a table" or updated, vim.log.levels.ERROR)
			return
		end

		-- Read upstream defaults again so removing an option restores its default.
		package.loaded.nvconfig = nil
		local ok_config, fresh_config = pcall(require, "nvconfig")
		package.loaded.nvconfig = config
		local statusline = ok_config and type(fresh_config.ui) == "table" and fresh_config.ui.statusline
		if type(statusline) ~= "table" or type(statusline.theme) ~= "string" then
			package.loaded.chadrc = old_chadrc
			vim.notify(
				ok_config and "chadrc.lua has an invalid ui.statusline config" or fresh_config,
				vim.log.levels.ERROR
			)
			return
		end

		local previous = config.ui.statusline
		config.ui.statusline = statusline
		local renderer = "nvchad.stl." .. statusline.theme
		local previous_renderer = package.loaded[renderer]
		package.loaded[renderer] = nil
		local loaded, err = pcall(require, renderer)
		if not loaded then
			package.loaded[renderer] = previous_renderer
			config.ui.statusline = previous
			package.loaded.chadrc = old_chadrc
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		apply_highlights()
		set_statusline()
		vim.cmd.redrawstatus()
	end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	desc = "Refresh NvChad UI highlights from the active colorscheme",
	callback = function()
		apply_highlights()
	end,
})
