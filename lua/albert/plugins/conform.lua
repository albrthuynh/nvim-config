return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
        -- Format on save using Conform (falls back to LSP if no formatter)
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },

        formatters_by_ft = {
            -- Biome: JS/TS ecosystem
            javascript = { "biome" },
            javascriptreact = { "biome" },
            typescript = { "biome" },
            typescriptreact = { "biome" },

            -- Biome does NOT format Python/Lua/C++; keep good native tools here.
            lua = { "stylua" },
            python = { "black" },
            cpp = { "clang_format" },
        },

        -- Optional: set formatexpr so gq and related use Conform
        notify_on_error = true,
    },
}
