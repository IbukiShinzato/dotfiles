-- =================================================
-- 1. Leaderキー設定
-- =================================================
vim.g.mapleader = " "

-- =================================================
-- 2. lazy.nvim 初期化
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
-- 3. 基本UI設定
-- =================================================
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.clipboard = ""

-- yankした時だけクリップボードに送る
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if vim.v.event.operator == "y" then
            vim.fn.setreg("+", vim.fn.getreg("0"))
        end
    end,
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- =================================================
-- 4. プラグイン設定
-- =================================================
require("lazy").setup({
    -- テーマ設定 (起動時に最優先で読み込むため lazy = false)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                },
            })
            vim.cmd[[colorscheme tokyonight]]
        end,
    },

    -- LSP管理と設定 (コードファイルを開いた時だけ読み込む)
    {
        "neovim/nvim-lspconfig",
        ft = { "rust", "c", "cpp", "go" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "rust_analyzer", "clangd", "gopls" },
            })

            -- LSP設定
            if vim.lsp.config then
                vim.lsp.config("rust_analyzer", {
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                        },
                    },
                })
                vim.lsp.config("clangd", {})
                vim.lsp.config("gopls", {})

                vim.lsp.enable("rust_analyzer")
                vim.lsp.enable("clangd")
                vim.lsp.enable("gopls")
            else
                local lspconfig = require("lspconfig")
                lspconfig.rust_analyzer.setup({
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                })
                lspconfig.clangd.setup({})
                lspconfig.gopls.setup({})
            end
        end,
    },

    -- 補完エンジン (文字入力を始めた瞬間、またはLSPが起動した時に読み込む)
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "LspAttach" },
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
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- fzf (ファイル検索用ショートカットキーが押された時に読み込む)
    {
        "junegunn/fzf.vim",
        cmd = { "Files", "GFiles", "Buffers", "Rg" },
        dependencies = { "junegunn/fzf" },
        config = function()
            vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
        end,
    },

    -- Peekaboo (レジスタ表示のキーを押した瞬間に読み込む)
    {
        "junegunn/vim-peekaboo",
        event = "BufReadPost", -- ファイルを読み込んだ後に裏でひっそり準備
        config = function()
            vim.g.peekaboo_window = "bo 20new"
        end,
    },

    -- 周辺プラグインのトリガー最適化
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPost", "BufNewFile" }, opts = {} },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = { "BufReadPost", "BufNewFile" } },
    { "lewis6991/gitsigns.nvim", event = { "BufReadPost", "BufNewFile" }, opts = {} },
})

-- =================================================
-- 5. キーバインド (LSP用アクション)
-- =================================================
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})

-- =================================================
-- 6. 自動フォーマット設定
-- =================================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs", "*.c", "*.h", "*.go" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
vim.opt.fixeol = true

-- モード切り替え
vim.keymap.set("i", "jj", "<Esc>")

-- 保存
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- ファイル検索 (fzfをコマンド経由で叩く)
vim.keymap.set("n", "<Leader>f", ":Files<CR>", { silent = true })

-- ウィンドウ移動
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- 行頭 / 行末移動
vim.keymap.set("n", "<C-a>", "^")
vim.keymap.set("n", "<C-e>", "$")
vim.keymap.set("n", "<C-k>", "d$") 
vim.keymap.set("i", "<C-k>", "<C-o>D") 

-- Space + r でrun scriptを走らす
vim.keymap.set("n", "<Leader>r", ":!./run.sh<CR>", { silent = true })
