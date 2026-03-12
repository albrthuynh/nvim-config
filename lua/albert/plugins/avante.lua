return {
    "yetone/avante.nvim",
    event = "VeryLazy", -- or "InsertEnter"
    lazy = false, -- eager-load for reliability
    version = false, -- always latest
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- or mini.icons
        "zbirenbaum/copilot.lua", -- ← depends on this!
    },
    opts = {
        provider = "copilot", -- this line enables your Copilot sub
        -- Optional: try a specific model if Copilot supports it (e.g., Claude variant)
        -- copilot = {
        --   model = "claude-3-5-sonnet",  -- check available names via CopilotChat or trial/error
        -- },
        behaviour = {
            auto_suggestions = false, -- set true if you want ghost-text from Copilot via avante
            auto_apply_diff_after_generation = false,
        },
        windows = {
            position = "right", -- or "left"
            width = 40,
        },
        -- Add more as needed (mappings, etc.)
    },
    build = "make", -- if needed for binary/deps
}
