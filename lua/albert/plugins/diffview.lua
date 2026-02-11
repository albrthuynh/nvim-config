-- View diffs in a tab (e.g. after Cursor CLI edits: open diff to see all changes)
return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewRefresh" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (all unstaged changes, incl. Cursor CLI)" },
        { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
    opts = {},
}
