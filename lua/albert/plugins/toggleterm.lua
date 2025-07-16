return {
    "akinsho/toggleterm.nvim",
    version = "*", -- Ensures you're using the latest version
    config = function()
        require("toggleterm").setup({
            size = 10, -- Default terminal height in horizontal mode
            open_mapping = [[<C-\>]], -- Shortcut to toggle terminal
            hide_numbers = true, -- Hide line numbers in terminal buffer
            shade_terminals = true, -- Enable shading for better visibility
            shading_factor = 2, -- Degree of darkening
            start_in_insert = true, -- Start in insert mode
            persist_size = true, -- Keep the same terminal size when toggling
            direction = "float", -- Terminal direction ("horizontal", "vertical", "float", "tab")
            close_on_exit = true, -- Close terminal when process exits
            shell = vim.o.shell, -- Use system shell
        })

        -- Keybindings to toggle different terminal types

        vim.api.nvim_set_keymap("n", "<S-t>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<S-t>", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
            "n",
            "<C-h>",
            "<cmd>ToggleTerm size=10 direction=horizontal<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<C-v>",
            "<cmd>ToggleTerm size=40 direction=vertical<CR>",
            { noremap = true, silent = true }
        )
    end,
}
