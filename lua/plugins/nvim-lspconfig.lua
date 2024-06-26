return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-nvim-lsp',
	},
	event = { "BufReadPre", "BufNewFile" },
	
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		require('mason').setup()
		local mason_lspconfig = require 'mason-lspconfig'
		mason_lspconfig.setup {
			ensure_installed = { 
				'rust_analyzer',
				'pyright'
			}
		}
		require('lspconfig').pyright.setup {
			capabilities = capabilities
		}
	end
}
