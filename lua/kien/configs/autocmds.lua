vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("KienYank", { clear = true }),
	desc = "Briefly highlight yanked text",
	callback = function()
		vim.hl.on_yank({ timeout = 180 })
	end,
})
