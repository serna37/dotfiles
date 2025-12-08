local opt = vim.opt

-- 行番号の表示
opt.number = true
opt.relativenumber = true

-- タブとインデントの設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 検索設定
opt.ignorecase = true
opt.smartcase = true

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- ノーマルモードでのキーマップ
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)

-- プラグイン管理
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  'jiangmiao/auto-pairs',
  'yuttie/comfortable-motion.vim',
  'rhysd/clever-f.vim',
  'unblevable/quick-scope',
  'junegunn/goyo.vim',
  'vim-airline/vim-airline',
  'joshdick/onedark.vim',
  'neoclide/coc.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'junegunn/fzf',
  'Exafunction/codeium.vim',
})

map('n', '<space>e',require('telescope').extensions.file_browser.file_browser, opts)

vim.cmd[[colorscheme onedark]]

