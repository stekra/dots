-- vim.opt.signcolumn = "yes:1"
vim.opt.signcolumn = "no"
vim.opt.linebreak = true
vim.opt.showbreak = "↪"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.fillchars = { eob = ' ' }
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.guicursor = "n-v-c-i:block"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winborder = "single"

vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.clipboard = "unnamedplus"

vim.g.netrw_banner = 0

vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")
vim.keymap.set({ "n", "v" }, "n", "nzz")
vim.keymap.set({ "n", "v" }, "N", "<Nzz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>e", ":Explore<CR>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>,", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)

vim.keymap.set("n", "gh", vim.diagnostic.open_float)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>r", ":w | !./build.sh<CR>")

vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/zenbones-theme/zenbones.nvim" },
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/folke/zen-mode.nvim" },
})

require("zen-mode").setup({
    window = {
        width = 70,
    }
})
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")

require("mason").setup()

vim.lsp.enable({ "lua_ls", "clangd", "omnisharp" })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })

        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "ZenBg", { bg = "none" })
    end,
})
vim.g.zenbones_compat = 1
vim.cmd.colorscheme("zenbones")
-- require("vague").setup({ bold = false, italic = false, })
-- vim.cmd.colorscheme("vague")

