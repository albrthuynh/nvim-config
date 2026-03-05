return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
        -- New main-branch API: no "configs" module, only setup + install
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        require("nvim-treesitter").install({
            "json",
            "javascript",
            "typescript",
            "tsx",
            "yaml",
            "html",
            "css",
            "prisma",
            "markdown",
            "markdown_inline",
            "svelte",
            "graphql",
            "bash",
            "lua",
            "vim",
            "dockerfile",
            "gitignore",
            "query",
            "vimdoc",
            "c",
            "cpp",
            "java",
        })

        -- Start treesitter for buffers (skip if no parser to avoid errors)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Treesitter indent is experimental; use built-in indent for C/C++/Lua
        -- (C/C++ also get cindent from options.lua for comment/newline behavior)
        local indent_skip_ft = { lua = true, c = true, cpp = true }
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                if indent_skip_ft[vim.bo.filetype] then
                    return
                end
                pcall(function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end)
            end,
        })

        require("nvim-ts-autotag").setup()
    end,
}
