local clang_format_style = table.concat({
  "{BasedOnStyle: LLVM",
  "IndentWidth: 2",
  "ContinuationIndentWidth: 4",
  "ColumnLimit: 100",
  "PointerAlignment: Left",
  "BinPackArguments: false",
  "BinPackParameters: OnePerLine",
  "AllowAllArgumentsOnNextLine: false",
  "AlignAfterOpenBracket: false",
  "Cpp11BracedListStyle: Block",
  "BreakBeforeBraces: Attach",
  "AllowShortBlocksOnASingleLine: Never",
  "AllowShortFunctionsOnASingleLine: None",
  "AllowShortLambdasOnASingleLine: None",
  "AllowShortIfStatementsOnASingleLine: Never",
  "AllowShortLoopsOnASingleLine: false}",
}, ", ")

local function has_clang_format_file(filename)
  return #vim.fs.find({ ".clang-format", "_clang-format" }, {
    path = vim.fs.dirname(filename),
    upward = true,
  }) > 0
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    -- Format on save using Conform (falls back to LSP if no formatter),
    -- except for C files where formatting is explicitly disabled.
    format_on_save = function(bufnr)
      if vim.bo[bufnr].filetype == "c" then
        return nil
      end
      return {
        timeout_ms = 10000,
        lsp_format = "fallback",
      }
    end,

    formatters_by_ft = {
      -- Biome: JS/TS ecosystem
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },

      -- Biome does NOT format Python/Lua/C++; keep good native tools here.
      lua = { "stylua" },
      python = { "black" },
      cpp = { "clang_format" },
    },

    formatters = {
      clang_format = {
        prepend_args = function(_, ctx)
          if has_clang_format_file(ctx.filename) then
            return { "--style=file" }
          end
          return { "--style=" .. clang_format_style }
        end,
      },
    },

    -- Optional: set formatexpr so gq and related use Conform
    notify_on_error = true,
  },
}
