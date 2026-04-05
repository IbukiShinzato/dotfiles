-- =================================================
-- 1. Leaderキー設定
-- =================================================
vim.g.mapleader = " "

-- =================================================
-- 2. lazy.nvim (プラグインマネージャ) の初期化
-- =================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- =================================================
-- 3. 基本UI設定
-- =================================================
vim.opt.number = true         -- 行番号
vim.opt.signcolumn = "yes"   -- git差分などの表示
vim.opt.termguicolors = true -- カラー有効化
vim.opt.background = "dark"   -- nightカラーに合わせてdarkに（lightだと白飛びします）
vim.opt.clipboard = "unnamedplus" -- クリップボド共有
vim.opt.splitright = true    -- 縦分割は右に
vim.opt.splitbelow = true    -- 横分割は下に

-- =================================================
-- 背景を透過（ターミナルの色を透かす）させる魔法の呪文
-- =================================================
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- インデント
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- =================================================
-- 4. プラグイン設定 (lazy.nvim)
-- =================================================
require("lazy").setup({

  -- カラースキーム
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme tokyonight-night")
  --   end,
  -- },

  -- fzf本体とvim用プラグイン (ここを追加！)
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      -- fzfのウィンドウを画面中央に浮かせる (シンプルでかっこいい)
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
    end,
  },

  -- 自動括弧
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- インデントガド
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Treesitter (構文解析)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Git差分
  { "lewis6991/gitsigns.nvim", opts = {} },
})

-- =================================================
-- 5. キーバインド
-- =================================================

-- モード切り替え
vim.keymap.set("i", "jj", "<Esc>")

-- 保存
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- ファイル検索 (fzf)
-- <Leader>f でファイルを探し、
-- 検索結果で Ctrl-v を押すと vsplit で開けます！
vim.keymap.set('n', '<Leader>f', ':Files<CR>', { silent = true })

-- ウィンドウ移動 (Ctrl + hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- 行頭 / 行末移動 (Bashライク)
vim.keymap.set("n", "<C-a>", "^")
vim.keymap.set("n", "<C-e>", "$")

