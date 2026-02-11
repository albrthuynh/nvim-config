return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Install parsers (runs async in background)
        require("nvim-treesitter").install({
            "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
            "prisma", "markdown", "markdown_inline", "svelte", "graphql",
            "bash", "lua", "vim", "dockerfile", "gitignore", "query",
            "vimdoc", "c", "cpp", "java",
        })

        -- Treesitter highlighting (nvim-treesitter 1.0 way)
        -- Skip filetypes without parsers (e.g. alpha, netrw) to avoid errors
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Treesitter-based indentation
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                pcall(function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end)
            end,
        })

        require("nvim-ts-autotag").setup()
    end,
}
