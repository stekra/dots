-- vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.showbreak = "↪"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "no"
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
-- vim.opt.completeopt = "menuone,noinsert,noselect"
-- vim.opt.showmode = false
vim.opt.pumheight = 10
-- vim.opt.pumblend = 10
-- vim.opt.winblend = 0
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.autoread = true

-- vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
-- vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Cursor down (line wrap)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Cursor up (line wrap)" })
vim.keymap.set({ "n", "v" }, "n", "nzzv", { desc = "Next search result (centered)" })
vim.keymap.set({ "n", "v" }, "N", "<Nzzv", { desc = "Previous search result (centered)" })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

local augroup = vim.api.nvim_create_augroup("UserConfig", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto-resize splits on window resize",
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("Colorscheme", {
  desc = "Set theme background to none",
  group = augroup,
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    end,
})
vim.cmd.colorscheme("default")

