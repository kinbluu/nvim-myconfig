vim.g.mapleader = " "

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

local editing_modes = { "n", "i", "v" }
vim.keymap.set(editing_modes, "<C-s>", "<cmd>silent write<CR>", { desc = "Save buffer" })
vim.keymap.set(editing_modes, "<S-Down>", "<cmd>t.<CR>", { silent = true, desc = "Duplicate line below" })
vim.keymap.set(editing_modes, "<S-Up>", "<cmd>t -1<CR>", { silent = true, desc = "Duplicate line above" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center cursor" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor throughout the buffer" }
)

vim.keymap.set("n", "<leader>re", "<cmd>restart<CR>", { desc = "Restart Neovim" })
vim.keymap.set("n", "q", "<cmd>quit<CR>", { silent = true, desc = "Quit window" })
