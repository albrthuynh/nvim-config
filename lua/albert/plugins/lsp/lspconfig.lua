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
                severity = { min = vim.diagnostic.severity.WARN },
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                },
            },
            underline = {
                severity = { min = vim.diagnostic.severity.WARN },
            },
            virtual_text = {
                severity = { min = vim.diagnostic.severity.WARN },
                virt_text_pos = "eol_right_align",
                format = function(diag)
                    local msg = diag.message:gsub("\n", " "):gsub("%s+", " ")
                    return (#msg > 50) and (msg:sub(1, 50) .. "…") or msg
                end,
            },
            update_in_insert = false,
            severity_sort = true,
        })

        -- === Improved diagnostic hover: auto-show + auto-close ===
        vim.opt.updatetime = 1000 -- CursorHold fires after this ms

        local diag_group = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true })
        local last_diag_win = nil

        -- Show diagnostic float when cursor rests
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = diag_group,
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local line = vim.api.nvim_win_get_cursor(0)[1] - 1
                local diags = vim.diagnostic.get(bufnr, { lnum = line })

                -- Close any previous diagnostic float first (prevents stacking)
                if last_diag_win and vim.api.nvim_win_is_valid(last_diag_win) then
                    vim.api.nvim_win_close(last_diag_win, true)
                    last_diag_win = nil
                end

                if #diags > 0 then
                    local float_opts = {
                        scope = "line",
                        focus = false,
                        border = "rounded", -- optional: nicer look
                        max_width = 100, -- optional: prevent super wide floats
                        header = "", -- optional: clean look
                        prefix = "",
                    }
                    local res = vim.diagnostic.open_float(float_opts)
                    -- open_float can return winid (number) or { winid = number } depending on Neovim version
                    if res then
                        last_diag_win = type(res) == "number" and res or res.winid
                    end
                end
            end,
        })

        -- Close diagnostic float when cursor moves
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = diag_group,
            callback = function()
                if last_diag_win and vim.api.nvim_win_is_valid(last_diag_win) then
                    vim.api.nvim_win_close(last_diag_win, true)
                    last_diag_win = nil
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

        -- Per-server config: clangd
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

        -- Disable diagnostics for C files (xv6 sanity)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "c",
            callback = function()
                vim.diagnostic.disable(0)
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
