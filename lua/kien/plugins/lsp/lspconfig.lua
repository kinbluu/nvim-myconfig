local picker = require("snacks").picker

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("KienLsp", { clear = true }),
	desc = "Set buffer-local LSP keymaps",
	callback = function(args)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
		end

		map("n", "gR", picker.lsp_references, "Show LSP references")
		map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "gd", picker.lsp_definitions, "Show LSP definitions")
		map("n", "gi", picker.lsp_implementations, "Show LSP implementations")
		map("n", "gt", picker.lsp_type_definitions, "Show LSP type definitions")
		map({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, "Show code actions")
		map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>D", picker.diagnostics_buffer, "Show buffer diagnostics")
		map("n", "df", vim.diagnostic.open_float, "Show line diagnostics")
		map("i", "<C-h>", vim.lsp.buf.signature_help, "Show signature help")
		map("n", "K", vim.lsp.buf.hover, "Show symbol documentation")
		map("n", "<leader>rs", "<cmd>lsp restart<CR>", "Restart LSP")
	end,
})

local severity = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local vue_language_server_path =
	vim.fs.joinpath(vim.env.MASON, "packages/vue-language-server/node_modules/@vue/language-server")

local servers = {
	html = true,
	pyright = true,
	clangd = true,
	jsonls = true,
	rust_analyzer = true,
	laravel_ls = true,
	vue_ls = true,
	cssls = {
		settings = {
			css = { lint = { unknownAtRules = "ignore" } },
			scss = { lint = { unknownAtRules = "ignore" } },
			less = { lint = { unknownAtRules = "ignore" } },
		},
	},
	intelephense = {
		root_markers = { "index.php", ".git", "composer.json" },
		filetypes = { "php", "blade" },
		settings = {
			intelephense = {
				files = {
					associations = { "*.php", "*.blade.php" },
					maxSize = 1000000,
				},
				environment = { includePaths = { "vendor" } },
			},
		},
	},
	emmet_language_server = {
		filetypes = {
			"astro",
			"css",
			"eruby",
			"html",
			"htmlangular",
			"htmldjango",
			"javascriptreact",
			"less",
			"pug",
			"sass",
			"scss",
			"svelte",
			"templ",
			"typescriptreact",
			"vue",
			"blade",
		},
		init_options = {
			includeLanguages = {},
			excludeLanguages = {},
			extensionsPath = {},
			preferences = {},
			showAbbreviationSuggestions = true,
			showExpandedAbbreviation = "always",
			showSuggestionsAsSnippets = true,
			syntaxProfiles = {},
			variables = {},
		},
	},
	tailwindcss = {
		filetypes = {
			"html",
			"css",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"vue",
			"astro",
		},
		init_options = { userLanguages = { astro = "html" } },
	},
	gopls = {
		settings = {
			gopls = {
				analyses = { unusedparams = true },
				staticcheck = true,
				gofumpt = true,
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				completion = { callSnippet = "Replace" },
				workspace = {
					library = {
						vim.env.VIMRUNTIME .. "/lua",
						"/usr/share/hypr/stubs",
						"${3rd}/luv/library",
					},
				},
			},
		},
	},
	vtsls = {
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server_path,
							languages = { "vue" },
							configNamespace = "typescript",
						},
					},
				},
			},
		},
	},
}

for name, opts in pairs(servers) do
	if type(opts) == "table" then
		vim.lsp.config(name, opts)
	end
end

vim.lsp.enable(vim.tbl_keys(servers))
