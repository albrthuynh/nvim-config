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

        -- Short inline message; full message on hover (CursorHold opens float)
        local max_inline = 50
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = "󰠠 ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
                texthl = {
                    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                    [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                    [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                },
            },
            virtual_text = {
                virt_text_pos = "eol_right_align", -- push message to the right edge of the window
                format = function(diag)
                    local msg = diag.message:gsub("\n", " "):gsub("%s+", " ")
                    if #msg > max_inline then
                        return msg:sub(1, max_inline) .. "…"
                    end
                    return msg
                end,
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Show full diagnostic when cursor rests on a line with diagnostics
        vim.opt.updatetime = 1000 -- CursorHold fires after this ms; keeps hover float responsive
        local diag_group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = diag_group,
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local line = vim.api.nvim_win_get_cursor(0)[1] - 1
                local diags = vim.diagnostic.get(bufnr, { lnum = line })
                if #diags > 0 then
                    vim.diagnostic.open_float({ scope = "line", focus = false })
                end
            end,
        })

        -- LspAttach keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, vim.tbl_extend("force", opts, { desc = desc }))
                end
                map("gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
                map("gi", "<cmd>Telescope lsp_implementations<CR>", "Show implementations")
                map("gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show type definitions")
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

        -- Default capabilities for all LSP servers (Neovim 0.11 vim.lsp.config API)
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

        -- Per-server config: clangd (hover, go-to-def, etc. for C/C++)
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            filetypes = { "c", "cpp", "objc", "objcpp" },
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
            },
            init_options = {
                fallbackFlags = { "--std=c++23" },
            },
        })

        -- Mason-LSPConfig v2: ensure installs; we enable servers explicitly (automatic_enable is unreliable on Neovim 0.11)
        local servers = {
            "ts_ls", "html", "cssls", "tailwindcss", "svelte", "lua_ls",
            "graphql", "emmet_ls", "prismals", "pyright", "clangd",
        }
        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_enable = true,
        })
        -- Explicitly enable each server so they attach to buffers (required for Neovim 0.11)
        for _, name in ipairs(servers) do
            pcall(vim.lsp.enable, name)
        end
    end,
}
