return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        local uv = vim.uv or vim.loop

        local donut = {
            frame = 0,
            timer = nil,
        }

        local function render_donut(angle_a, angle_b)
            local width = 64
            local height = 22
            local chars = ".,-~:;=!*#$@"
            local output = {}
            local zbuffer = {}

            for i = 1, width * height do
                output[i] = " "
                zbuffer[i] = 0
            end

            local sin_a = math.sin(angle_a)
            local cos_a = math.cos(angle_a)
            local sin_b = math.sin(angle_b)
            local cos_b = math.cos(angle_b)

            for theta = 0, 6.28, 0.14 do
                local sin_theta = math.sin(theta)
                local cos_theta = math.cos(theta)

                for phi = 0, 6.28, 0.08 do
                    local sin_phi = math.sin(phi)
                    local cos_phi = math.cos(phi)
                    local circle_x = cos_theta + 2
                    local depth = 1 / (sin_phi * circle_x * sin_a + sin_theta * cos_a + 5)
                    local torus_y = sin_phi * circle_x * cos_a - sin_theta * sin_a
                    local x = math.floor(width / 2 + 30 * depth * (cos_phi * circle_x * cos_b - torus_y * sin_b))
                    local y = math.floor(height / 2 + 15 * depth * (cos_phi * circle_x * sin_b + torus_y * cos_b))
                    local idx = x + width * y
                    local luminance = math.floor(
                        8
                            * (
                                (sin_theta * sin_a - sin_phi * cos_theta * cos_a) * cos_b
                                - sin_phi * cos_theta * sin_a
                                - sin_theta * cos_a
                                - cos_phi * cos_theta * sin_b
                            )
                    )

                    if y >= 0 and y < height and x >= 1 and x <= width and depth > zbuffer[idx] then
                        local shade = math.min(#chars, math.max(1, luminance + 1))

                        zbuffer[idx] = depth
                        output[idx] = luminance > 0 and chars:sub(shade, shade) or "."
                    end
                end
            end

            local lines = {}
            for y = 0, height - 1 do
                local line = {}
                for x = 1, width do
                    line[x] = output[x + width * y]
                end
                lines[#lines + 1] = table.concat(line)
            end

            return lines
        end

        local function stop_donut()
            if donut.timer then
                donut.timer:stop()
                donut.timer:close()
                donut.timer = nil
            end
        end

        local function start_donut()
            stop_donut()

            local bufnr = vim.api.nvim_get_current_buf()
            if vim.bo[bufnr].filetype ~= "alpha" then
                return
            end

            donut.timer = uv.new_timer()
            donut.timer:start(
                0,
                80,
                vim.schedule_wrap(function()
                    if
                        not vim.api.nvim_buf_is_valid(bufnr)
                        or vim.api.nvim_get_current_buf() ~= bufnr
                        or vim.bo[bufnr].filetype ~= "alpha"
                    then
                        stop_donut()
                        return
                    end

                    donut.frame = donut.frame + 1
                    dashboard.section.header.val = render_donut(donut.frame * 0.07, donut.frame * 0.035)
                    pcall(alpha.redraw)
                end)
            )
        end

        -- Header
        dashboard.section.header.val = render_donut(0, 0)

        -- Buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file", "<cmd>ene<CR>"),
            dashboard.button("f", "󰱼  Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("r", "󰁯  Restore session", "<cmd>SessionRestore<CR>"),
            dashboard.button("c", "  Config", "<cmd>edit ~/.config/nvim/init.lua<CR>"),
            dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
        }

        -- Footer
        dashboard.section.footer.val = {
            "",
            "“Ship it. Fix it. Make it clean.”",
        }

        -- Layout spacing
        dashboard.config.layout = {
            { type = "padding", val = 2 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 2 },
            dashboard.section.footer,
        }

        alpha.setup(dashboard.config)

        -- Disable folding
        local alpha_group = vim.api.nvim_create_augroup("AlphaDashboardDonut", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = alpha_group,
            pattern = "alpha",
            callback = function()
                vim.opt_local.foldenable = false
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            group = alpha_group,
            pattern = "AlphaReady",
            callback = function()
                start_donut()
            end,
        })

        vim.api.nvim_create_autocmd("BufEnter", {
            group = alpha_group,
            callback = function()
                start_donut()
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            group = alpha_group,
            pattern = "AlphaClosed",
            callback = function()
                stop_donut()
            end,
        })

        vim.api.nvim_create_autocmd({ "BufLeave", "VimLeavePre" }, {
            group = alpha_group,
            callback = function()
                stop_donut()
            end,
        })
    end,
}
