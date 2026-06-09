return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local common_dotfile_globs = {
      ".env*",
      ".dockerignore",
      ".editorconfig",
      ".eslintignore",
      ".eslintrc*",
      ".gitattributes",
      ".gitignore",
      ".gitmodules",
      ".npmrc",
      ".nvmrc",
      ".node-version",
      ".prettierignore",
      ".prettierrc*",
      ".stylelintignore",
      ".stylelintrc*",
      ".yarnrc",
    }
    local generated_directory_globs = {
      ".git",
      ".cache",
      ".next",
      ".nuxt",
      "build",
      "coverage",
      "dist",
      "node_modules",
      "target",
      "vendor",
    }
    local find_files_command

    if vim.fn.executable("rg") == 1 then
      find_files_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "*",
        "--glob",
        "!.*",
      }

      for _, glob in ipairs(common_dotfile_globs) do
        vim.list_extend(find_files_command, { "--glob", glob })
      end

      for _, glob in ipairs(generated_directory_globs) do
        vim.list_extend(find_files_command, { "--glob", "!" .. glob .. "/**", "--glob", "!**/" .. glob .. "/**" })
      end
    end

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = find_files_command,
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
