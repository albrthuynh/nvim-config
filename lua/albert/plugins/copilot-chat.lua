return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main", -- Use canary for latest features/stable updates (main is sometimes behind)
    dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim if you use that
        { "nvim-lua/plenary.nvim" },
    },
    build = function()
        vim.defer_fn(function()
            vim.cmd("UpdateRemotePlugins") -- Needed for some remote plugin features
        end, 0)
    end,
    event = "VeryLazy",
    config = function()
        require("CopilotChat").setup({
            -- Default config is good for most people
            -- Optional customizations below
            model = "claude-sonnet-4", -- or gpt-4o, o1-mini, claude-3-opus, etc. (Copilot-supported models)
            auto_follow_cursor = false, -- Don't auto-scroll chat to cursor
            show_help = true, -- Show keybinding hints
            auto_insert_mode = true, -- Enter insert mode when opening chat
            context = nil, -- nil = auto, or 'buffer', 'selection', etc.
            window = {
                layout = "vertical", -- "vertical", "horizontal", "float"
                width = 0.4, -- fraction of screen width
                height = 0.6,
            },
            -- mappings = { ... }        -- customize keymaps if needed
        })

        -- Optional: quick keymaps
        vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CopilotChat<CR>", { desc = "CopilotChat - Open" })
        vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat - Explain selection" })
        vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat - Fix diagnostics" })
        vim.keymap.set("n", "<leader>ct", "<cmd>CopilotChatTests<CR>", { desc = "CopilotChat - Generate tests" })
    end,
}
