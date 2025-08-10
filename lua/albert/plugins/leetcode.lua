return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have nvim-treesitter installed
    dependencies = {
        -- picker dependency examples
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    cmd = { "LeetCode" }, -- loads plugin only when command is called
    keys = {
        { "<leader>lc", "<cmd>LeetCode<cr>", desc = "Open LeetCode menu" },
    },
    opts = {
        -- you can set your config here
        lang = "python",
        theme = "dark",
        -- other config options from the plugin docs
    },
}
