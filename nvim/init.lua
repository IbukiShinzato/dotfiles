-- =================================================
-- 1. Leaderキー設定 (変更なし)
-- =================================================
vim.g.mapleader = " "

-- =================================================
-- 2. lazy.nvim 初期化 (変更なし)
-- =================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- =================================================
-- 3. 基本UI設定 (変更なし)
-- =================================================
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.clipboard = ""

-- yankした時だけクリップボードに送る
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		if vim.v.event.operator == "y" then
			vim.fn.setreg("+", vim.fn.getreg("0"))
		end
	end,
})

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- =================================================
-- 4. プラグイン設定 (LSP関連を追加！)
-- =================================================
require("lazy").setup({
	-- LSP管理と設定
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Mason本体の起動
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer" },
			})

			-- [最新の書き方] vim.lsp.config を使用
			-- これにより、警告が消え、Neovim 0.11 以降の最適化が適用されます
			if vim.lsp.config then
				vim.lsp.config("rust_analyzer", {
					-- ここにサーバー固有の設定が必要なら書けます
				})
			else
				-- 0.10 以前の互換性を保つためのフォールバック
				require("lspconfig").rust_analyzer.setup({})
			end
		end,
	},

	-- 補完エンジン (LSPの能力を最大限引き出す)
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enterで補完確定
					["<Tab>"] = cmp.mapping.select_next_item(), -- Tabで次を選択
					["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift-Tabで前を選択
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- fzf本体とプラグイン
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		config = function()
			vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
		end,
	},

	-- レジスタの内容を表示
	{
		"junegunn/vim-peekaboo",
		config = function()
			vim.g.peekaboo_window = "bo 20new"
		end,
	},

	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "lewis6991/gitsigns.nvim", opts = {} },
})

-- =================================================
-- 5. キーバインド (LSP用アクションを追加！)
-- =================================================

-- LSPアクション (コード上での操作)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		-- gd: 定義ジャンプ (Go Definition)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		-- K: 型情報やドキュメントを表示 (Hover)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		-- <Leader>rn: 変数名などを一括置換 (Rename)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		-- gr: その変数が使われている場所を一覧表示 (References)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

-- モード切り替え
vim.keymap.set("i", "jj", "<Esc>")

-- 保存
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- ファイル検索 (fzf)
vim.keymap.set("n", "<Leader>f", ":Files<CR>", { silent = true })

-- ウィンドウ移動
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- 行頭 / 行末移動
vim.keymap.set("n", "<C-a>", "^")
vim.keymap.set("n", "<C-e>", "$")
