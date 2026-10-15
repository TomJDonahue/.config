vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>p', '<cmd>lua vim.pack.update(nil, { offline = true })<CR>',
  { desc = 'gra to delete inactive plugins' })

vim.pack.add {
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  "https://github.com/mfussenegger/nvim-dap",
  {
    src = "https://github.com/igorlfs/nvim-dap-view",
    version = vim.version.range("1.*")
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
  },
}

require("opts")
require("keybinds")
require("lsp")
require('colorscheme')
require('dap_plugin')
require('treesitter_plugin')
require('build_and_run')
require('minipick_plugin')
require('miniclue_plugin')

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  jump = { float = true },
}


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.statusline').setup {
  use_icons = vim.g.have_nerd_font,
}
require('mini.pairs').setup {
  version = false,
  event = "InsertEnter",
  opts = {
    -- toggle mapping or customize behavior here if needed
    modes = { insert = true, command = false, terminal = false },
  },
}

require('mini.diff').setup {
  view = {
    style = 'sign',
    signs = {
      add = '+',
      change = '~',
      delete = '_',
      topdelete = '‾',
      changedelete = '~',
    }
  }
}

if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

require('mini.files').setup()

require("mini.completion").setup({
  delay = { completion = 100, info = 100, signature = 50 },
  window = {
    signature = { height = 25, width = 80, border = "rounded" },
  },
})
-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
