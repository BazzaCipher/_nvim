-- Keymappings Locations:
-- lua\plugins\nvim-cmp.lua - Autocomplete mappings
-- lua\plugins\telescope.lua - Telescope mappings
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('options')
require('keymaps')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{ import = 'plugins' },
}, {})

-- Use Nord theme
vim.cmd.colorscheme 'nord'

-- Telescope prefix naming
require('which-key').register({['<leader>f'] = { name = '+file' } })

-- Leap motions
require('leap').add_default_mappings()

-- Set up status line
require('lualine').setup{ options = { theme = 'nord' } }

-- Gitsigns
require('gitsigns').setup()

-- Configure LSP and Default Keymaps
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
	-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- Configure LSP
-- require'lspconfig'.rust_analyzer.setup{
-- 	server = {
-- 		settings = {
-- 			['rust-analyzer'] = {
-- 				diagnostics = {
-- 					enable = false
-- 				}
-- 			}
-- 		},
-- 		on_attach = on_attach,
-- 	}
-- }
local rusttoolsopts = {
	tools = {
		autoSetHints = true,
	},
	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy"
				}
			}
		}
	}
}

require('rust-tools').setup(rusttoolsopts)

-- Commenting
require('Comment').setup()

require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('dapui').setup({
	icons = { expanded = "▾", collapsed = "▸" },
		mappings = {
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
	expand_lines = vim.fn.has("nvim-0.7"),
	layouts = {
		{
			elements = {
				"scopes",
			},
			size = 0.3,
			position = "right"
			},
			{
				elements = {
					"repl",
					"breakpoints"
				},
				size = 0.3,
				position = "bottom",
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			border = "single",
			mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
	max_type_length = nil,
	},
})

local dap = require('dap')
vim.fn.sign_define('DapBreakpoint', { text = '🐞' }) -- Looks pretty

local dapremap = function ()
	local nmapdap = function(keys, func, desc)
		if desc then
			desc = 'DAP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	-- Start debugging session
	nmapdap('<leader>ds', function()
		dap.continue()
		require('dapui').toggle({})
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>=', false, true, true), 'n', false) -- Even space buffers end
	end, '[S]tart debugger')

	-- Set breakpoints, get variable values, step into/out of functions, etc.
	-- nmapdap("<leader>dl", require("dap.ui.widgets").hover)
	nmapdap("<leader>dc", dap.continue, '[C]ontinue')
	nmapdap("<leader>db", dap.toggle_breakpoint, 'Toggle [B]reakpoint')
	nmapdap("<leader>dn", dap.step_over, 'Step Over')
	nmapdap("<leader>di", dap.step_into, 'Step [I]nto')
	nmapdap("<leader>do", dap.step_out, 'Step [O]ut')
	-- nmapdap("<leader>dC", function()
	-- 	dap.clear_breakpoints()
	-- 	require("notify")("Breakpoints cleared", "warn")
	-- end)
 
	-- Close debugger and clear breakpoints
	nmapdap("<leader>de", function()
	  dap.clear_breakpoints()
	  ui.toggle({})
	  dap.terminate()
	  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
	  require("notify")("Debugger session ended", "warn")
	end, '[E]nd debugger')
end

dapremap()
