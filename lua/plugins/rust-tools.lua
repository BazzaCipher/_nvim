-- Rust tools on top of rust-analyzer tools for nvim
-- https://github.com/sharksforarms/neovim-rust/blob/master/neovim-init-lsp-cmp-rust-tools.lua
return {
	'simrat39/rust-tools.nvim',
	event = { "BufRead *.rs", "BufRead Cargo.*" },
	opts = {
		tools = {
			runnables = {
				use_telescope = true,
			},
			inlay_hints = {
				auto = true,
				show_parameter_hints = false,
				parameter_hints_prefix = "",
				other_hints_prefix = "",
			},
		},

		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
		server = {
			-- on_attach is a callback called when the language server attachs to the buffer
			on_attach = function(_, bufnr)
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

				-- TODO: Set up the which-keys
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
			end,

			settings = {
				-- to enable rust-analyzer settings visit:
				-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
				["rust-analyzer"] = {
					-- enable clippy on save
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		},
	}
}

-- local on_attach = function(_, bufnr)
-- 	-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- 	-- to define small helper and utility functions so you don't have to repeat yourself
-- 	-- many times.
-- 	--
-- 	-- In this case, we create a function that lets us more easily define mappings specific
-- 	-- for LSP related items. It sets the mode, buffer and description for us each time.
-- 	local nmap = function(keys, func, desc)
-- 		if desc then
-- 			desc = 'LSP: ' .. desc
-- 		end
--
-- 		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
-- 	end
--
-- 	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
-- 	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--
-- 	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
-- 	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
-- 	nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
-- 	nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
-- 	-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
-- 	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
-- 	-- See `:help K` for why this keymap
-- 	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
-- 	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
-- 	-- Lesser used LSP functionality
-- 	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
-- 	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
-- 	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
-- 	nmap('<leader>wl', function()
-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 	end, '[W]orkspace [L]ist Folders')
--
-- 	-- Create a command `:Format` local to the LSP buffer
-- 	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
-- 		vim.lsp.buf.format()
-- 	end, { desc = 'Format current buffer with LSP' })
-- end
--
