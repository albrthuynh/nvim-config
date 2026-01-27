return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = { "Leet" },
    keys = { { "<leader>lc", "<cmd>Leet<cr>", desc = "Open LeetCode" } },
    opts = {
        lang = "python3",
        picker = "telescope",
        plugins = { non_standalone = true },

        cookies = {
            LEETCODE_SESSION = os.getenv("LEETCODE_SESSION"),
            csrftoken = os.getenv("LEETCODE_CSRF"),
        },

        -- Then sign in inside Neovim:
        --
        -- Log in at leetcode.com in your browser.
        --
        -- DevTools → Network tab → click a GraphQL request on leetcode.com.
        --
        -- Copy the Request Headers → Cookie value (the whole line’s value, not “Set-Cookie”).

        endpoint = "leetcode.com", -- or "leetcode.cn" if that’s your account
    },
}
