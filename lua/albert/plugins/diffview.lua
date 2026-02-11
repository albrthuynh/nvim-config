-- Diff viewer for reviewing edits (e.g. from Cursor CLI).
--
-- Full diff tab: <leader>gD opens side-by-side before/after for all changed files.
--   - Switch panes: <leader>dh (left), <leader>dl (right).
--   - Reject whole file: in file list press X (restore).
--   - Reject one hunk: in the "after" (right) pane press do (diff obtain from left).
--   - Accept: leave as-is or stage with -/s in file list.
--
-- Inline per-hunk (stay in file): use gitsigns — ]h/[h next/prev, <leader>hp preview,
--   <leader>hs accept (stage), <leader>hr reject (reset).
return {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        view = {
            default = {
                layout = "diff2_horizontal", -- side-by-side before (left) / after (right)
            },
        },
        file_panel = {
            listing_style = "tree",
            win_config = { position = "left", width = 35 },
        },
    },
    keys = {
        -- Open diff of all working-tree changes (e.g. after Cursor CLI edits)
        { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff view: all changes (before/after)" },
        -- Close diff tab
        { "<leader>gC", "<cmd>DiffviewClose<cr>", desc = "Diff view: close" },
        -- File history for current file
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff view: file history" },
        -- Switch panes (work from anywhere in diffview tab: file panel or left/right pane)
        {
            "<leader>dh",
            function()
                if require("diffview.lib").get_current_view() then
                    vim.cmd("wincmd h")
                end
            end,
            desc = "Diff view: focus left pane",
        },
        {
            "<leader>dl",
            function()
                if require("diffview.lib").get_current_view() then
                    vim.cmd("wincmd l")
                end
            end,
            desc = "Diff view: focus right pane",
        },
    },
}
