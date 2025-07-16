return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" }, -- Core Copilot support
            { "nvim-lua/plenary.nvim", branch = "master" }, -- Required for async and curl
        },
        build = "make tiktoken", -- Only needed on macOS/Linux
        opts = {
            -- You can configure CopilotChat.nvim options here if needed
        },
        -- Optional: you can lazy-load on command if you want
        -- cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" }
        keys = {
            -- Normal mode
            { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
            { "<leader>zm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },

            -- Visual mode (selection-based prompts)
            { "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
            { "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
            { "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
            { "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
            { "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
            { "<leader>zt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
            { "<leader>zs", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
        },
    },
}
