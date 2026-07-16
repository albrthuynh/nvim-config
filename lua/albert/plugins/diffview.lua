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

-- The file panel auto-fits its width to the longest rendered line (icons + tree
-- indent + filename + status), clamped between MIN and half the editor width.
local MIN_PANEL_WIDTH = 25
local function fit_panel_width(bufid, winid)
    if not (bufid and vim.api.nvim_buf_is_valid(bufid)) then return end
    if not (winid and vim.api.nvim_win_is_valid(winid)) then return end
    local max = 0
    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufid, 0, -1, false)) do
        local w = vim.fn.strdisplaywidth(line)
        if w > max then max = w end
    end
    local cap = math.floor(vim.o.columns * 0.5)
    local width = math.max(MIN_PANEL_WIDTH, math.min(max + 1, cap))
    vim.api.nvim_win_set_width(winid, width)
end

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
            -- Starting width; the view_opened hook resizes to fit the filenames.
            win_config = { position = "left", width = MIN_PANEL_WIDTH },
        },
        hooks = {
            -- The file list renders asynchronously after the view opens, so attach
            -- to the panel buffer and re-fit the width on every render (this also
            -- covers the working-tree list changing while the diff is open).
            view_opened = function(view)
                local panel = view.panel
                if not (panel and panel.bufid) then return end
                vim.api.nvim_buf_attach(panel.bufid, false, {
                    on_lines = vim.schedule_wrap(function()
                        fit_panel_width(panel.bufid, panel.winid)
                    end),
                })
                vim.schedule(function() fit_panel_width(panel.bufid, panel.winid) end)
            end,
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
