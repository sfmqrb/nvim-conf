vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.shiftwidth = 4 -- spaces used for each step of (auto)indent
vim.opt.expandtab = true -- convert tabs to spaces

-- Install lazy.nvim package manager if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Load custom key mappings (e.g. in lua/mappings.lua)
require("mappings")

-- Plugin definitions using lazy.nvim.
-- Only include plugins that are not managed by your custom plugin files.
require("lazy").setup({
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "rstacruz/vim-closer",
    {
        "mfussenegger/nvim-jdtls",
    },
    {
        "dasupradyumna/midnight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("midnight")
        end,
    },
    { "dasupradyumna/midnight.nvim", lazy = false, priority = 1 },
    {
        "tpope/vim-dispatch",
        opt = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    },
    { "andymass/vim-matchup", event = "VimEnter" },
    { "glacambre/firenvim", build = ":call firenvim#install(0)" },
    {
        "w0rp/ale",
        ft = { "sh", "zsh", "bash", "c", "cpp", "cmake", "html", "markdown", "racket", "vim", "tex" },
    },
    {
        "haorenW1025/completion-nvim",
        opt = true,
        dependencies = {
            { "hrsh7th/vim-vsnip", opt = true },
            { "hrsh7th/vim-vsnip-integ", opt = true },
        },
    },
    { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", cmd = "MarkdownPreview" },
    {
        "glepnir/galaxyline.nvim",
        branch = "main",
        config = function()
            require("nvim-treesitter.statusline")
        end,
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    },
    -- Remove duplicate gitsigns (its configuration now lives in custom/plugins if desired)
    -- Other LSP & related plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            "folke/neodev.nvim",
        },
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
    },
    { -- Autocompletion (managed in custom/plugins/nvim_cmp.lua)
        "hrsh7th/nvim-cmp",
    },
    -- Telescope and extensions
    -- { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup {
          defaults = {
            path_display = { "tail" },
          }
        }
      end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },
    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    -- Theme (choose one; here we use nightfox)
    { "EdenEast/nightfox.nvim" },
    -- Other plugins that you manage via custom files are imported below
    { import = "custom.plugins" },
    -- Example: Dracula theme if you ever need it
    { "dracula/vim", as = "dracula" },
    { "tpope/vim-fugitive" },
    {
        "folke/zen-mode.nvim",
        lazy = false,
        opts = {},
    },
})

-- Disable netrw for nvim-tree.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
-- [[ Global Options ]]
vim.o.hlsearch = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
-- Set explicitly rather than append: this nvim's default diffopt already has
-- linematch:40, and a duplicate linematch entry silently disables word-level
-- DiffText highlighting. followwrap keeps long lines wrapping in diff mode.
vim.o.diffopt = "internal,filler,closeoff,linematch:60,followwrap,algorithm:histogram"

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

-- [[ Basic Keymaps ]]
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on Yank ]]
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = yank_group,
    pattern = "*",
})

-- [[ Telescope Configuration ]]
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
})
pcall(require("telescope").load_extension, "fzf")

vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sl", function()
    vim.cmd('echo expand("%:p")')
end, { desc = "[S]earch [L]ocation" })

-- Show diagnostics (errors/warnings) inline at the end of the offending line
vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
})

-- [[ LSP Configuration ]]
local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = true,
                },
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
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
            gopls = {
                completeUnimported = true,
                usePlaceholders = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            },
        },
    },

}

require("neodev").setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason").setup()

-- Register per-server config (mason-lspconfig v2 auto-enables installed servers)
for server_name, config in pairs(servers) do
    vim.lsp.config(server_name, vim.tbl_deep_extend("force", config, {
        capabilities = capabilities,
        on_attach = on_attach,
    }))
end

-- lspconfig's biome root_dir passes nested marker tables to vim.fs.root based on
-- a has('nvim-0.11.3') check, which this 0.12.0-dev build passes without actually
-- supporting nested markers ("invalid value (table) ... in 'concat'"). Flat-marker
-- replacement; drop once nvim is rebuilt from a newer commit.
vim.lsp.config("biome", {
    capabilities = capabilities,
    root_dir = function(bufnr, on_dir)
        local config_dir = vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
        if not config_dir then
            return -- only attach in projects that actually use biome
        end
        local project_root = vim.fs.root(bufnr, {
            "package-lock.json", "yarn.lock", "pnpm-lock.yaml",
            "bun.lockb", "bun.lock", "deno.lock",
        })
        on_dir(project_root or config_dir)
    end,
})

-- The auto-enable path can start clients without calling the on_attach injected
-- above, leaving buffers with no LSP mappings; LspAttach fires for every client.
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

        local home = vim.fn.expand("~")
        local jdtls_root = home .. "/.local/share/jdtls"
        local config_dir = jdtls_root .. "/config_linux"

        local project_root = jdtls.setup.find_root({
            ".git", "mvnw", "gradlew", "pom.xml", "build.gradle"
        })
        if not project_root then
            vim.notify("jdtls: no project root found", vim.log.levels.WARN)
            return
        end

        local workspace_dir =
            home .. "/.local/share/jdtls/workspace/" ..
            vim.fn.fnamemodify(project_root, ":p:h:t")

        jdtls.start_or_attach({
            cmd = {
                jdtls_root .. "/bin/jdtls",
                "-configuration", config_dir,
                "-data", workspace_dir,
                "--jvm-arg=-Xmx2G",
            },
            root_dir = project_root,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
    end,
})

