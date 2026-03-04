vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- delete without copying
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { noremap = true })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- VS Code specific keybindings (only active when running in VS Code)
if vim.g.vscode then
    local vscode = require("vscode-neovim")

    -- File explorer toggle
    keymap.set("n", "<leader>ee", function()
        vscode.action("workbench.action.toggleSidebarVisibility")
    end, { desc = "Toggle file explorer" })

    -- Fuzzy finder
    keymap.set("n", "<leader>ff", function()
        vscode.action("workbench.action.quickOpen")
    end, { desc = "Find files" })

    -- Clear search highlights
    keymap.set("n", "<leader>nh", function()
        vscode.action("search.action.clearSearchResults")
    end, { desc = "Clear search highlights" })

    -- Go to the definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

    -- Window/split management
    keymap.set("n", "<leader>sv", function()
        vscode.action("workbench.action.splitEditor")
    end, { desc = "Split window vertically" })
    keymap.set("n", "<leader>sh", function()
        vscode.action("workbench.action.splitEditorDown")
    end, { desc = "Split window horizontally" })
    keymap.set("n", "<leader>se", function()
        vscode.action("workbench.action.evenEditorWidths")
    end, { desc = "Make splits equal size" })
    keymap.set("n", "<leader>sx", function()
        vscode.action("workbench.action.closeActiveEditor")
    end, { desc = "Close current split" })

    -- Tab management
    keymap.set("n", "<leader>to", function()
        vscode.action("workbench.action.files.newUntitledFile")
    end, { desc = "Open new tab" })
    keymap.set("n", "<leader>tx", function()
        vscode.action("workbench.action.closeActiveEditor")
    end, { desc = "Close current tab" })
    keymap.set("n", "<leader>tn", function()
        vscode.action("workbench.action.nextEditor")
    end, { desc = "Go to next tab" })
    keymap.set("n", "<leader>tp", function()
        vscode.action("workbench.action.previousEditor")
    end, { desc = "Go to previous tab" })
    keymap.set("n", "<leader>tf", function()
        vscode.action("workbench.action.splitEditor")
    end, { desc = "Open current buffer in new tab" })
end
