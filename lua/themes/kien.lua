local function color(group, field, fallback)
	local value = vim.api.nvim_get_hl(0, { name = group, link = false, create = false })[field]
	return value and ("#%06x"):format(value) or fallback
end

local bg = color("Normal", "bg", "#222222")
local fg = color("Normal", "fg", "#eeeeee")
local panel = color("CursorLine", "bg", bg)
local muted = color("Comment", "fg", fg)
local blue = color("Function", "fg", fg)
local purple = color("Keyword", "fg", fg)

return {
	base_16 = {},
	base_30 = {
		black = bg,
		darker_black = bg,
		white = fg,
		black2 = panel,
		one_bg = bg,
		one_bg2 = panel,
		one_bg3 = panel,
		statusline_bg = bg,
		lightbg = panel,
		grey = panel,
		light_grey = muted,
		blue = blue,
		nord_blue = blue,
		red = color("DiagnosticError", "fg", fg),
		green = color("String", "fg", fg),
		yellow = color("DiagnosticWarn", "fg", fg),
		orange = color("Number", "fg", fg),
		purple = purple,
		dark_purple = purple,
		cyan = color("Type", "fg", fg),
		teal = color("Constant", "fg", fg),
	},
}
