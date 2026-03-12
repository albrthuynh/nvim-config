return {
    "zbirenbaum/copilot.lua",
    lazy = false, -- must be set up before avante's copilot provider
    build = ":Copilot auth", -- optional: forces auth on install
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = false, -- often disable ghost-text if using avante for suggestions
            },
            panel = { enabled = false }, -- disable if not needed
            -- Add any other custom opts (filetypes, etc.)
        })
    end,
}
