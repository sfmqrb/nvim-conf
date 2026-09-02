vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1 -- nvim-tree replaces netrw
vim.g.loaded_netrwPlugin = 1

vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
-- Set explicitly rather than append: this nvim's default diffopt already has
-- linematch:40, and a duplicate linematch entry silently disables word-level
-- DiffText highlighting. followwrap keeps long lines wrapping in diff mode.
vim.o.diffopt = "internal,filler,closeoff,linematch:60,followwrap,algorithm:histogram"

-- Install lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("mappings")

require("lazy").setup({
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "rstacruz/vim-closer",
    "mfussenegger/nvim-jdtls",
    {
        "dasupradyumna/midnight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("midnight")
        end,
    },
    { "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Focus", "Start" } },
    { "andymass/vim-matchup", event = "VimEnter" },
    { "glacambre/firenvim", build = ":call firenvim#install(0)" },
    {
        "w0rp/ale",
        ft = { "sh", "zsh", "bash", "c", "cpp", "cmake", "html", "markdown", "racket", "vim", "tex" },
    },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            "folke/neodev.nvim",
        },
    },
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    "hrsh7th/nvim-cmp", -- configured in custom/plugins/nvim_cmp.lua
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = { "tail" },
                    mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
                },
            })
            pcall(require("telescope").load_extension, "fzf")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },
    { "folke/zen-mode.nvim", lazy = false, opts = {} },
    { import = "custom.plugins" },
})

-- GitHub-style diff colors: green for added/changed, red for removed,
-- with the actually-changed text in a brighter green (DiffText)
local function github_diff_colors()
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#12261e" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#12261e" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#1d572d", bold = true })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#301b1f", fg = "#6e4a52" })
end
github_diff_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = github_diff_colors })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sl", function()
    vim.cmd('echo expand("%:p")')
end, { desc = "[S]earch [L]ocation" })

vim.diagnostic.config({ virtual_text = true, severity_sort = true })

-- [[ LSP ]]
local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc and "LSP: " .. desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
end

local servers = {
    clangd = {
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        settings = { clangd = { includePath = { "/usr/include", "/usr/local/include" } } },
    },
    lua_ls = {
        settings = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enable = false } } },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = { cargo = { allFeatures = true }, checkOnSave = { command = "clippy" } },
        },
    },
    pyright = {
        settings = {
            python = {
                analysis = { autoSearchPaths = true, diagnosticMode = "openFilesOnly", useLibraryCodeForTypes = true },
            },
        },
    },
    texlab = {
        settings = {
            texlab = {
                build = { onSave = false }, -- vimtex handles compilation
                chktex = { onOpenAndSave = true },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                analyses = { unusedparams = true, shadow = true },
                staticcheck = true,
            },
        },
    },
}

require("neodev").setup()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()

-- Register per-server config (mason-lspconfig v2 auto-enables installed servers)
for server_name, config in pairs(servers) do
    config.capabilities = capabilities
    vim.lsp.config(server_name, config)
end

-- Auto-enabled clients don't get a per-server on_attach; LspAttach covers every client.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            on_attach(client, args.buf)
        end
    end,
})

require("mason-lspconfig").setup({
    ensure_installed = { "clangd", "lua_ls", "rust_analyzer", "gopls", "pyright", "texlab" },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local jdtls = require("jdtls")
        local project_root = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
        if not project_root then
            vim.notify("jdtls: no project root found", vim.log.levels.WARN)
            return
        end

        local jdtls_root = vim.fn.expand("~") .. "/.local/share/jdtls"
        jdtls.start_or_attach({
            cmd = {
                jdtls_root .. "/bin/jdtls",
                "-configuration", jdtls_root .. "/config_linux",
                "-data", jdtls_root .. "/workspace/" .. vim.fn.fnamemodify(project_root, ":p:h:t"),
                "--jvm-arg=-Xmx2G",
            },
            root_dir = project_root,
            capabilities = capabilities,
        })
    end,
})
