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

        -- claude provider
        -- provider = "claude",
        --
        -- providers = {
        --     claude = {
        --         endpoint = "https://api.anthropic.com",
        --         model = "claude-sonnet-4-20250514",
        --         auth_type = "api",
        --     },
        -- },
        -- end of claude provider set up

        behaviour = {
            auto_suggestions = false, -- set true if you want ghost-text from Copilot via avante
            auto_apply_diff_after_generation = false, -- This prevents auto-applying changes
            enable_cursor_planning_mode = true,
            enable_fastapply = false, -- This ensures we see diffs before applying
            support_paste_from_clipboard = false, -- Disable to avoid direct paste without diff
            enable_token_counting = true, -- enable token counting
        },
        windows = {
            position = "right", -- or "left"
            width = 40,
        },
        -- Diff configuration for proper approval workflow
        diff = {
            auto_review = false, -- Set to false to manually review diffs
            focus_on_apply = true, -- Focus on apply action when diff is shown
            list_opener = "copen", -- How to open the diff list
        },
        edit = {
            auto_apply = false, -- Never auto-apply edits
            diff_preview = true, -- Always show diff preview
        },

        -- Ensure suggestions mode shows diffs
        suggestions = {
            use_default_keymaps = true,
        },

        -- Mappings for diff approval workflow
        mappings = {
            ask = "<leader>aa",
            edit = "<leader>ae",
            refresh = "<leader>ar",
            diff = {
                ours = "co",
                theirs = "ct",
                all_theirs = "ca",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            suggestion = {
                accept = "<M-l>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
        },

        -- Hints for better UX
        hints = { enabled = true },
    },
    build = "make", -- if needed for binary/deps
}
