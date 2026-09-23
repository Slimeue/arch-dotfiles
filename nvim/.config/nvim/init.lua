-- ~/.config/nvim/init.lua
-- User config entry point. Arch's system init (/etc/xdg/nvim/sysinit.vim)
-- already loaded before this and added /usr/share/vim/vimfiles to runtimepath.

-- Leader must be set before any mapping that uses it.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Misc
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Keymaps
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
-- Visual mode formats just the selection (qmlls supports range formatting).
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format" })

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  callback = function() vim.hl.on_yank() end,
})

-- ---------------------------------------------------------------------------
-- lazy.nvim plugin manager
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true, notify = false }, -- background check for updates
  change_detection = { notify = false },
})

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy plugin manager" })

-- Transparent background (see lua/transparency.lua)
require("transparency").setup()
