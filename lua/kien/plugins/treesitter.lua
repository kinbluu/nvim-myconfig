local treesitter = require("nvim-treesitter")

local parsers = {
	"lua",
	"luadoc",
	"printf",
	"vim",
	"vimdoc",
	"python",
	"typescript",
	"javascript",
	"html",
	"blade",
	"php_only",
}

local function install_parsers()
	treesitter.install(parsers)
end

vim.api.nvim_create_user_command("TSInstallAll", install_parsers, { desc = "Install configured Tree-sitter parsers" })
install_parsers()

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("KienTreesitter", { clear = true }),
	desc = "Start Tree-sitter highlighting when a parser is available",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
		end
	end,
})
