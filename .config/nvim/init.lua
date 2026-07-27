-- Keep the same editing behavior as ~/.vimrc.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.path:append("**")
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.hlsearch = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.clipboard = { "unnamed", "unnamedplus" }
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("i", "<C-H>", "<C-W>", { desc = "Delete previous word" })
vim.keymap.set("n", "<Tab>", ">>_")
vim.keymap.set("n", "<S-Tab>", "<<_")
vim.keymap.set("i", "<S-Tab>", "<C-D>")
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
    desc = "Remove trailing whitespace",
})

-- Install lazy.nvim automatically on the first start.
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
    local result = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazy_path,
    })
    if vim.v.shell_error ~= 0 then
        error("Could not install lazy.nvim:\n" .. result)
    end
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "dark",
                term_colors = true,
            })
            require("onedark").load()
        end,
    },
    {
        "vim-airline/vim-airline",
        dependencies = { "vim-airline/vim-airline-themes" },
        init = function()
            vim.g.airline_theme = "onedark"
        end,
    },
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
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            local python_root_markers = {
                "pyproject.toml",
                "uv.lock",
                "pyrightconfig.json",
                "requirements.txt",
                ".git",
            }

            local function set_python_path(_, config)
                local root = config.root_dir
                if not root then
                    return
                end

                local python = vim.env.VIRTUAL_ENV
                    and (vim.env.VIRTUAL_ENV .. "/bin/python")
                    or (root .. "/.venv/bin/python")

                if vim.fn.executable(python) == 1 then
                    config.settings = config.settings or {}
                    config.settings.python = config.settings.python or {}
                    config.settings.python.pythonPath = python
                end
            end

            vim.lsp.config("basedpyright", {
                root_markers = python_root_markers,
                before_init = set_python_path,
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })
            vim.lsp.config("ruff", {
                root_markers = python_root_markers,
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright",
                    "ruff",
                    "ts_ls",
                    "gopls",
                    "rust_analyzer",
                },
                automatic_enable = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, opts)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, opts)
                end,
            })
        end,
    },
}, {
    change_detection = { notify = false },
})

-- uv helpers. Commands run from the current project's LSP root when possible.
local function project_root()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if clients[1] and clients[1].config.root_dir then
        return clients[1].config.root_dir
    end
    return vim.fn.getcwd()
end

local function run_in_terminal(command)
    if vim.fn.executable("uv") ~= 1 then
        vim.notify("uv is not installed or is not in PATH", vim.log.levels.ERROR)
        return
    end

    local cwd = project_root()
    vim.cmd("botright new")
    vim.fn.jobstart(command, {
        cwd = cwd,
        term = true,
    })
    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("UvSync", function()
    run_in_terminal({ "uv", "sync" })
end, { desc = "Run uv sync" })

vim.api.nvim_create_user_command("UvVenv", function()
    run_in_terminal({ "uv", "venv" })
end, { desc = "Create a uv virtual environment" })

vim.api.nvim_create_user_command("UvRun", function(options)
    local command = { "uv", "run" }
    vim.list_extend(command, vim.split(options.args, "%s+", { trimempty = true }))
    run_in_terminal(command)
end, {
    nargs = "+",
    desc = "Run a command with uv",
})
