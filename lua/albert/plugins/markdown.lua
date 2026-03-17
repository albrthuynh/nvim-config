return {
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "markdown", "rmd", "org", "norg" },
    opts = {
      markdown = {
        headline_highlights = {
          "Headline1",
          "Headline2",
          "Headline3",
          "Headline4",
          "Headline5",
          "Headline6",
        },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    config = function()
      -- Open preview in the default browser
      vim.g.mkdp_browser = ""
      -- Auto-close preview window when leaving the buffer
      vim.g.mkdp_auto_close = 1
    end,
  },
}