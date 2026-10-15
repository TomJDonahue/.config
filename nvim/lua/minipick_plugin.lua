require('mini.pick').setup {}
do
    local pick = require 'mini.pick'
    local extra = require 'mini.extra'

    -- Helper function for the custom config file search
    local function search_neovim_files()
        pick.builtin.files({}, {
            source = {
                cwd = vim.fn.stdpath 'config',
                name = 'Neovim Config Files',
            }
        })
    end

    -- Hidden files matcher to mimic your commented Telescope rule
    local function search_hidden_files()
        -- mini.pick uses git by default if available; fallback uses custom tool commands
        pick.builtin.files({ tool = 'rg' }, { source = { name = 'Search Files (All)' } })
    end

    local function todo_picker()
        local pattern = 'TODO|HACK|DEBUG|FIXME|BUG'
        local raw = vim.fn.systemlist({ 'rg', '--vimgrep', '--no-heading', '--smart-case', pattern })
        local items = {}
        for _, line in ipairs(raw) do
            local path, lnum, col, text = line:match('^(.-):(%d+):(%d+):(.*)$')
            if path then
                local cleaned = text:gsub('^%s*', '')
                items[#items + 1] = {
                    path = path,
                    lnum = tonumber(lnum),
                    col = tonumber(col),
                    text = string.format('%s:%s:%s:\t%s', path, lnum, col, cleaned),
                }
            end
        end

        MiniPick.start({
            source = {
                items = items,
                name = 'Todos/Hacks/Debugs',
                choose = function(item)
                    if not item then return end

                    local win_target = MiniPick.get_picker_state().windows.target
                    if win_target and vim.api.nvim_win_is_valid(win_target) then
                        vim.api.nvim_set_current_win(win_target)
                    end

                    vim.cmd('edit ' .. vim.fn.fnameescape(item.path))
                    vim.api.nvim_win_set_cursor(0, { item.lnum, math.max(item.col - 1, 0) })
                    vim.cmd('normal! zz')
                end,
            },
        })
    end
    vim.keymap.set('n', '<leader>st', todo_picker, { desc = '[S]earch [T]odos' })
    vim.keymap.set('n', '<leader>sh', function() pick.builtin.help() end, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', function() extra.pickers.keymaps() end, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', search_hidden_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', function() pick.builtin.pickers() end, { desc = '[S]earch [S]elect Pickers' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw', function() extra.pickers.grep({ pattern = vim.fn.expand('<cword>') }) end,
        { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', function() pick.builtin.grep_live() end, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', function() extra.pickers.diagnostic() end, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', function() pick.builtin.resume() end, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', function() extra.pickers.oldfiles() end,
        { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sc', function() extra.pickers.commands() end, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader><leader>', function() pick.builtin.buffers() end, { desc = '[ ] Find existing buffers' })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('mini-pick-lsp-attach', { clear = true }),
        callback = function(event)
            local buf = event.buf
            vim.keymap.set('n', 'grr', function() extra.pickers.lsp({ scope = 'references' }) end,
                { buffer = buf, desc = '[G]oto [R]eferences' })
            vim.keymap.set('n', 'gri', function() extra.pickers.lsp({ scope = 'implementation' }) end,
                { buffer = buf, desc = '[G]oto [I]mplementation' })
            vim.keymap.set('n', 'grd', function() extra.pickers.lsp({ scope = 'definition' }) end,
                { buffer = buf, desc = '[G]oto [D]efinition' })
            vim.keymap.set('n', 'gO', function() extra.pickers.lsp({ scope = 'document_symbol' }) end,
                { buffer = buf, desc = 'Open Document Symbols' })
            vim.keymap.set('n', 'gW', function() extra.pickers.lsp({ scope = 'workspace_symbol' }) end,
                { buffer = buf, desc = 'Open Workspace Symbols' })
            vim.keymap.set('n', 'grt', function() extra.pickers.lsp({ scope = 'type_definition' }) end,
                { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end
    })

    vim.keymap.set('n', '<leader>sn', search_neovim_files, { desc = '[S]earch [N]eovim files' })
end
