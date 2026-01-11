local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.background = "light"  
vim.opt.termguicolors = true

-- 3. プラグイン設定
require("lazy").setup({
  -- インデントガイド
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Treesitter 
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Git表示
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- 白背景でも見やすいカラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-day]]) 
    end,
  },
})

vim.keymap.set('n', '<C-k>', 'd$')
vim.keymap.set('n', '<C-a>', '^')
vim.keymap.set('n', '<C-e>', '$')

vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = false 
vim.opt.background = "light" 
vim.cmd([[colorscheme default]])
