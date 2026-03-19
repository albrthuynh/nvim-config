return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "codecompanion" },
      },
      ft = { "markdown", "codecompanion" },
    },
  },
  opts = {
    interactions = {
      chat = { adapter = "copilot" },
      inline = { adapter = "copilot" },
    },
    display = {
      chat = {
        show_header_separator = false,
      },
    },
    opts = {
      log_level = "DEBUG",
    },
  },
}
