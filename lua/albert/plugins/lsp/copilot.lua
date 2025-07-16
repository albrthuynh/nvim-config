return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        -- Optional: Disable default tab mapping
        vim.g.copilot_no_tab_map = true

        -- Accept suggestion with Ctrl+J
        vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

        -- Optional: Next/prev suggestions
        vim.api.nvim_set_keymap("i", "<C-]>", "<Plug>(copilot-next)", {})
        vim.api.nvim_set_keymap("i", "<C-[>", "<Plug>(copilot-previous)", {})

        -- Optional: Dismiss suggestion
        vim.api.nvim_set_keymap("i", "<C-X>", "<Plug>(copilot-dismiss)", {})
    end,
}
