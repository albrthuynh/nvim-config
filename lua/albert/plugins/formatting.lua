return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                -- Use <leader>mp to format manually if needed.
                python = {},
            },
            format_on_save = function(bufnr)
                if vim.bo[bufnr].filetype == "python" then
                    return
                end
                -- Only use Conform formatters above; no LSP fallback (avoids aggressive LSP formatters).
                return { lsp_fallback = false, async = false, timeout_ms = 2000 }
            end,
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true, -- manual format can use LSP if you want
                async = false,
                timeout_ms = 2000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
