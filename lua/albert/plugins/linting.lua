return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        -- Disable pylint "missing docstring" warnings (C0114 = module, C0116 = function/method)
        lint.linters.pylint = lint.linters.pylint or {}
        local pylint_args = lint.linters.pylint.args or {}
        lint.linters.pylint.args = vim.list_extend(pylint_args, {
            "--disable=missing-module-docstring,missing-function-docstring",
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

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
