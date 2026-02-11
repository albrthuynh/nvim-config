return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- Disable pylint "missing docstring" warnings (C0114 = module, C0116 = function/method)
        lint.linters.pylint = lint.linters.pylint or {}
        local pylint_args = lint.linters.pylint.args or {}
        lint.linters.pylint.args = vim.list_extend(pylint_args, {
            "--disable=missing-module-docstring,missing-function-docstring,broad-exception-raised",
        })

        -- Disable cpplint "No copyright message" (legal/copyright)
        lint.linters.cpplint = lint.linters.cpplint or {}
        local cpplint_args = lint.linters.cpplint.args or {}
        lint.linters.cpplint.args = vim.list_extend(cpplint_args, {
            "--filter=-legal/copyright",
        })

        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            svelte = { "eslint_d" },
            python = { "pylint" },
            c = { "cpplint" },
            cpp = { "cpplint" },
        }

        -- Lint only on demand (<leader>l). By default only LSP diagnostics show (VS Code–like).
        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Run linter for current file" })
    end,
}
