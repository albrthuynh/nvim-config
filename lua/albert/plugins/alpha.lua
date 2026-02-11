return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header
    dashboard.section.header.val = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "     █████╗ ██╗     ██████╗ ███████╗██████╗ ████████╗ ",
      "    ██╔══██╗██║     ██╔══██╗██╔════╝██╔══██╗╚══██╔══╝ ",
      "    ███████║██║     ██████╔╝█████╗  ██████╔╝   ██║    ",
      "    ██╔══██║██║     ██╔══██╗██╔══╝  ██╔══██╗   ██║    ",
      "    ██║  ██║███████╗██████╔╝███████╗██║  ██║   ██║    ",
      "    ╚═╝  ╚═╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝    ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "                 systems • backend • build fast       ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    }

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
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
