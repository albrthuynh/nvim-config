return {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        provider = "copilot",

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

        mode = "agentic",
        behaviour = {
            auto_apply_diff_after_generation = false,
            auto_approve_tool_permissions = false,
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "zbirenbaum/copilot.lua",
        -- The below dependencies are optional.
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
    },
}
