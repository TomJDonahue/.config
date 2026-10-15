vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Set Open Float' })
vim.diagnostic.config { jump = { float = true } }

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = 'Format current buffer' })
vim.keymap.set('n', '<leader>j', '<cmd>%!jq .<CR>')

vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
end, { desc = 'Trigger/resummon LSP completion' })

vim.keymap.set('n', '<leader>e', '<cmd> lua MiniFiles.open()<CR>')
