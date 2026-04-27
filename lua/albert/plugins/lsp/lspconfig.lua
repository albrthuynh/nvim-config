return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Drop clangd's "Too many errors emitted, stopping now" meta-diagnostic so it
        -- never appears in the UI (it's not a real source error).
        local orig_diag_set = vim.diagnostic.set
        vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
            local list = diagnostics
            if list and #list > 0 then
                list = vim.tbl_filter(function(d)
                    local code = d.code
                    if code == "fatal_too_many_errors" then return false end
                    if type(code) == "string" and code:find("fatal_too_many_errors") then return false end
                    if d.message and d.message:find("fatal_too_many_errors") then return false end
                    return true
                end, list)
            end
            return orig_diag_set(namespace, bufnr, list, opts)
        end

        -- Only show errors in the UI (like VS Code default): hide warnings/hints from
        -- style linters (e.g. clang-tidy) so we only see core issues (missing includes,
        -- undeclared identifiers, type errors).
        local max_inline = 50

        vim.diagnostic.config({
            signs = {
                severity = { min = vim.diagnostic.severity.ERROR },
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                },
            },
            underline = {
                severity = { min = vim.diagnostic.severity.ERROR },
            },
            virtual_text = {
                severity = { min = vim.diagnostic.severity.ERROR },
                virt_text_pos = "eol_right_align",
                format = function(diag)
                    local msg = diag.message:gsub("\n", " "):gsub("%s+", " ")
                    return (#msg > max_inline) and (msg:sub(1, max_inline) .. "…") or msg
                end,
            },
            update_in_insert = false,
            severity_sort = true,
        })

        -- LspAttach keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, vim.tbl_extend("force", opts, { desc = desc }))
                end

                map("gR", vim.lsp.buf.references, "Show LSP references")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gd", vim.lsp.buf.definition, "Show LSP definitions")
                map("gi", vim.lsp.buf.implementation, "Show implementations")
                map("gt", vim.lsp.buf.type_definition, "Show type definitions")
                map("<leader>ca", vim.lsp.buf.code_action, "Code actions (n/v)")
                map("<leader>rn", vim.lsp.buf.rename, "Smart rename")
                map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics")
                map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                map("K", vim.lsp.buf.hover, "Hover documentation")
                map("<leader>rs", ":LspRestart<CR>", "Restart LSP")
            end,
        })

        -- Default capabilities for all LSP servers
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- Per-server config: lua_ls
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        })

        -- Per-server config: clangd (no --clang-tidy so we only get compiler/semantic
        -- diagnostics: missing includes, undeclared ids, type errors; no style/lint noise)
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
            cmd = {
                "clangd",
                "--background-index",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
            },
            init_options = {
                fallbackFlags = { "-ferror-limit=0" },
            },
        })

        -- Per-server config: pyright (prefer project roots; reduce noise outside project context)
        vim.lsp.config("pyright", {
            capabilities = capabilities,
            root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        typeCheckingMode = "basic",
                    },
                },
            },
        })

        -- Per-server config: ts_ls (attach to real TS/JS projects only)
        vim.lsp.config("ts_ls", {
            capabilities = capabilities,
            root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
            single_file_support = false,
        })

        -- Disable diagnostics for C files (xv6 sanity)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "c",
            callback = function()
                vim.diagnostic.enable(false, { bufnr = 0 })
            end,
        })

        -- Mason-LSPConfig setup
        local servers = {
            "ts_ls",
            "html",
            "cssls",
            "tailwindcss",
            "svelte",
            "lua_ls",
            "graphql",
            "emmet_ls",
            "prismals",
            "pyright",
            "clangd",
        }

        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_enable = true,
        })

        -- Explicitly enable each server (important for Neovim 0.11+)
        for _, name in ipairs(servers) do
            pcall(vim.lsp.enable, name)
        end
    end,
}
