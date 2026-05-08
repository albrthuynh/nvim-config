if vim.lsp and vim.lsp.get_clients then
    vim.lsp.get_active_clients = function(opts)
        return vim.lsp.get_clients(opts)
    end
end

require("albert.core.options")
require("albert.core.keymaps")
