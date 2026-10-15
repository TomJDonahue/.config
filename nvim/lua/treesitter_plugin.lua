require('nvim-treesitter').setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath 'data' .. '/site',
}

require('nvim-treesitter').install { 'odin', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'json' }

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if ok then
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
        end
    end,
})
