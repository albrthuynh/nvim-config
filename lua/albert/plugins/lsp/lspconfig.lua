return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
        -- Make sure these point to the current org (if not already updated)
        -- "mason-org/mason.nvim",
        -- "mason-org/mason-lspconfig.nvim",
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap

        -- Your LspAttach autocmd is perfect → keep it unchanged
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)
                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
            end,
        })

        -- Capabilities (unchanged)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Diagnostic signs (unchanged)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- ──────────────────────────────────────────────────────────────
        -- New pattern: automatic_enable + manual vim.lsp.config overrides
        -- ──────────────────────────────────────────────────────────────

        -- Let mason-lspconfig auto-enable all installed servers
        -- (calls vim.lsp.enable() behind the scenes using nvim-lspconfig defaults)
        require("mason-lspconfig").setup({
            ensure_installed = {
                -- Add your servers here if you want auto-install
                -- "lua_ls", "clangd", "jdtls", "svelte", "graphql", "emmet_ls",
                -- ...
            },
            automatic_enable = true, -- default anyway, but explicit is good
            -- If you ever need to exclude one (e.g. special plugin handles it):
            -- automatic_enable = { exclude = { "rust_analyzer" } }
        })

        -- Now override/extend only the servers that need custom config
        -- (these merge on top of nvim-lspconfig's defaults)

        vim.lsp.config("jdtls", {
            -- root_dir already good in defaults usually; keep if needed
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern("pom.xml", "gradlew", ".git")(fname)
            end,
            -- add any other jdtls-specific settings here
        })

        vim.lsp.config("clangd", {
            cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt", ".git")(
                    fname
                )
            end,
        })

        vim.lsp.config("svelte", {
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePost", {
                    pattern = { "*.js", "*.ts" },
                    callback = function(ctx)
                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                    end,
                })
            end,
        })

        vim.lsp.config("graphql", {
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })

        vim.lsp.config("emmet_ls", {
            filetypes = {
                "html",
                "typescriptreact",
                "javascriptreact",
                "css",
                "sass",
                "scss",
                "less",
                "svelte",
            },
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                },
            },
        })

        -- If you have other servers with no overrides → nothing needed!
        -- They get auto-enabled with good defaults if installed via Mason.
    end,
}
