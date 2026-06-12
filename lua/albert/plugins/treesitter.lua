return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter").setup {
            -- install_dir = vim.fn.stdpath("data") .. "/site",
        }

        -- enable treesitter highlighting (provided by Neovim core)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- enable treesitter indentation (experimental, from nvim-treesitter)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                if vim.bo.filetype ~= "lua" then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })

        -- ensure parsers are installed (async)
        require("nvim-treesitter").install {
            "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
            "prisma", "markdown", "markdown_inline", "svelte", "graphql",
            "bash", "lua", "vim", "dockerfile", "gitignore", "query",
            "vimdoc", "c", "cpp", "java", "python",
        }

        require("nvim-ts-autotag").setup()
    end,
}
