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
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    -- テーマ設定 (独立させて定義)
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

    -- LSP管理と設定
    {
        "neovim/nvim-lspconfig",
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
                -- Neovim 0.11+ の書き方
                vim.lsp.config("rust_analyzer", {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                })

                vim.lsp.config("clangd", {})
                vim.lsp.config("gopls", {})

                -- サーバーを有効化
                vim.lsp.enable("rust_analyzer")
                vim.lsp.enable("clangd")
                vim.lsp.enable("gopls")
            else
                -- 0.10 以前の互換性用
                local lspconfig = require("lspconfig")
                lspconfig.rust_analyzer.setup({})
                lspconfig.clangd.setup({})
                lspconfig.gopls.setup({})
            end
        end,
    },

    -- 補完エンジン
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

    -- fzf
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
            vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
        end,
    },

    -- Peekaboo
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

-- ファイル検索
vim.keymap.set("n", "<Leader>f", ":Files<CR>", { silent = true })

-- ウィンドウ移動
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- 行頭 / 行末移動
vim.keymap.set("n", "<C-a>", "^")
vim.keymap.set("n", "<C-e>", "$")
