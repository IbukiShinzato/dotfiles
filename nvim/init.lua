-- 1. lazy.nvim の自動インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 視認性のための設定（プラグイン読み込み前に実行）
vim.opt.background = "light"  -- 背景が白いことをNeovimに教える
vim.opt.termguicolors = true

-- 3. プラグイン設定
require("lazy").setup({
  -- インデントガイド
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Treesitter (エラーが出やすい config 部分を一度削除し、後で設定します)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Git表示
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- 白背景でも見やすいカラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-day]]) -- 明るい背景用のテーマ
    end,
  },
})

-- 4. あなたのキーバインド
vim.keymap.set('n', '<C-k>', 'dd')
vim.keymap.set('n', '<C-a>', '^')
vim.keymap.set('n', '<C-e>', '$')

-- 5. 基本設定
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = false -- TrueColorをあえてOFFにする
vim.opt.background = "light"  -- 背景を明るいモードに固定
vim.cmd([[colorscheme default]]) -- 標準の色に戻す
