-- Common options
local opts = {
	noremap = true,				-- Non-recursive
	silent = true,				-- Do not show message
}

-- Better windows navigation, taking Ctrl-{hjkl}
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)
vim.keymap.set('n', '<C-s>', '<C-w>s', opts)
vim.keymap.set('n', '<C-s><C-s>', '<C-w>s', opts)

-- Better text skipping and hopping
vim.keymap.set('n', '<C-f>', 'zz4k', opts)
vim.keymap.set('n', '<C-b>', 'zz4j', opts)

-- Control N for new terminal
vim.keymap.set('n', '<C-n>', ':sp | term<CR>', opts)

-- Better command windows navigation
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', opts)
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j', opts)
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k', opts)
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', opts)
vim.keymap.set('n', '<A-h>', '<C-w>h', opts)
vim.keymap.set('n', '<A-j>', '<C-w>j', opts)
vim.keymap.set('n', '<A-k>', '<C-w>k', opts)
vim.keymap.set('n', '<A-l>', '<C-w>l', opts)

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Keymap specifically for end of quotes escaping
vim.keymap.set('i', '<C-d>', '<C-o>a')

