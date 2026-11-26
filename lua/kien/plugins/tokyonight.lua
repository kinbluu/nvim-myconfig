local cache_home = vim.env.XDG_CACHE_HOME
if not cache_home or cache_home == "" then
	cache_home = vim.fn.expand("~/.cache")
end

local palette_dir = vim.fs.joinpath(cache_home, "ryoku")
local palette_file = vim.fs.joinpath(palette_dir, "colors.json")

local function read_palette()
	local file = io.open(palette_file, "r")
	if not file then
		return
	end
	local raw = file:read("*a")
	file:close()

	local ok, decoded = pcall(vim.json.decode, raw)
	if not ok or type(decoded) ~= "table" then
		return
	end

	local colors = {}
	for index = 0, 8 do
		local key = "color" .. index
		local value = decoded[key]
		if type(value) ~= "string" or #value ~= 7 or not value:match("^#%x+$") then
			return
		end
		colors[key] = value:lower()
	end
	return colors
end

local palette
local function tint(colors)
	if not palette then
		return
	end

	local p = palette
	colors.bg, colors.bg_dark, colors.bg_float = p.color0, p.color0, p.color0
	colors.bg_popup, colors.bg_sidebar, colors.bg_statusline = p.color0, p.color0, p.color0
	colors.fg, colors.fg_float = p.color7, p.color7
	colors.fg_dark, colors.fg_sidebar, colors.fg_gutter, colors.comment = p.color8, p.color8, p.color8, p.color8
	colors.red, colors.green, colors.yellow = p.color1, p.color2, p.color3
	colors.blue, colors.magenta, colors.cyan = p.color4, p.color5, p.color6
	colors.purple, colors.teal, colors.orange = p.color5, p.color6, p.color3
end

local function refresh_palette()
	local updated = read_palette()
	if not updated or vim.deep_equal(palette, updated) then
		return
	end

	palette = updated
	local name = vim.g.colors_name
	if name and name:match("^tokyonight%-") then
		vim.cmd.colorscheme(name)
	end
end

local watcher = vim.uv.new_fs_event()
local function watch_palette()
	if not watcher or watcher:is_active() or watcher:is_closing() then
		return
	end

	-- Ryoku replaces colors.json atomically, so watch its directory for renames.
	watcher:start(palette_dir, {}, function(err, filename)
		if err then
			watcher:stop()
		elseif not filename or filename == "colors.json" then
			vim.schedule(refresh_palette)
		end
	end)
end

local group = vim.api.nvim_create_augroup("KienWallpaperPalette", { clear = true })
vim.api.nvim_create_autocmd("FocusGained", {
	group = group,
	desc = "Reconnect to the Ryoku palette after regaining focus",
	callback = function()
		watch_palette()
		refresh_palette()
	end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	once = true,
	desc = "Close the Ryoku palette watcher",
	callback = function()
		if watcher and not watcher:is_closing() then
			watcher:close()
		end
	end,
})

watch_palette()
palette = read_palette()
require("tokyonight").setup({ on_colors = tint })
vim.cmd.colorscheme("tokyonight")
