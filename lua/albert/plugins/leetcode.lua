return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim", -- <— ensure this is installed
    },
    cmd = { "leet" },
    keys = { { "<leader>lc", "<cmd>Leet<cr>", desc = "Open LeetCode" } },
    opts = {
        lang = "python3",
        picker = "telescope", -- <— tell leetcode.nvim which picker you’re using
        plugins = { non_standalone = true }, -- lets you run inside a normal session
        -- leave `theme` out for now
    },
}
