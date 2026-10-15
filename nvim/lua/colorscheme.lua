vim.cmd.colorscheme 'habamax'

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "MsgArea", { bg = "#1c1c1c" })

vim.api.nvim_set_hl(0, 'MatchParen', {
    fg = '#d75f87',   -- Bright pink text
    bg = 'none',      -- Dark gray background highlight
    bold = true,      -- Make it pop out
    underline = false -- Disable standard underlines if preferred
})
