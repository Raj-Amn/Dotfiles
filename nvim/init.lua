vim.pack.add {
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/y9san9/y9nika.nvim',
	'https://github.com/wakatime/vim-wakatime',
	'https://github.com/brenoprata10/nvim-highlight-colors',
	'https://github.com/ibhagwan/fzf-lua',
}

vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.undotree')
vim.cmd.packadd('nvim.difftool')

vim.g.mapleader = ','
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = '80'
vim.opt.textwidth = 80
vim.opt.completeopt = 'menu,menuone,fuzzy,noinsert'
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.wildoptions:append { 'fuzzy' }
vim.opt.path:append { '**' }
vim.opt.smoothscroll = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.cmd.colorscheme('y9nika')

-- disable mouse popup yet keep mouse enabled
vim.cmd [[
aunmenu PopUp
autocmd! nvim.popupmenu
]]

-- Only highlight with treesitter
vim.cmd('syntax off')

require("nvim-highlight-colors").setup {
	render = 'virtual',
	virtual_symbol = '⚫︎',
	virtual_symbol_suffix = '',
}

require('oil').setup {
	keymaps = { ['<C-h>'] = false },
	columns = { 'size', 'mtime' },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
}

-- fzf-lua setup
require('fzf-lua').setup({
	winopts = {
		height = 0.90,
		width = 0.90,
		border = 'rounded',
		preview = {
			border = 'rounded',
			wrap = 'nowrap',
			hidden = 'nohidden',
			vertical = 'down:50%',
			horizontal = 'right:50%',
			layout = 'flex',
			flip_columns = 120,
		},
	},
	fzf_opts = {
		['--layout'] = 'reverse',
		['--info'] = 'inline',
		['--ansi'] = '',
		['--preview-window'] = 'border-rounded',
	},
	fzf_colors = {
		['fg'] = { 'fg', '#dddddd' },
		['bg'] = { 'bg', '#0e1415' },
		['hl'] = { 'fg', '#71ade7' },
		['fg+'] = { 'fg', '#dfdf8e' },
		['bg+'] = { 'bg', '#0e1415' },
		['hl+'] = { 'fg', '#71ade7' },
		['info'] = { 'fg', '#95cb82' },
		['prompt'] = { 'fg', '#71ade7' },
		['pointer'] = { 'fg', '#dfdf8e' },
		['marker'] = { 'fg', '#95cb82' },
		['spinner'] = { 'fg', '#71ade7' },
		['header'] = { 'fg', '#aaaaaa' },
	},
	files = {
		prompt = 'Files❯ ',
		cmd = 'fd --type f --hidden --follow --exclude .git',
		git_icons = true,
		file_icons = true,
		color_icons = true,
	},
	grep = {
		prompt = 'Grep❯ ',
		input_prompt = 'Grep For❯ ',
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
		git_icons = true,
		file_icons = true,
		color_icons = true,
	},
	buffers = {
		prompt = 'Buffers❯ ',
		file_icons = true,
		color_icons = true,
	},
})

-- Keymaps
vim.keymap.set('n', '<leader><leader>', ':Oil<CR>', { silent = true })
vim.keymap.set({'n','v'}, '<C-y>', '"+y', { silent = true })

vim.keymap.set('n', '<leader>a', function()
	vim.cmd('$argadd %')
	vim.cmd('argdedup')
end)
vim.keymap.set('n', '<C-h>', function() vim.cmd('silent! 1argument') end)
vim.keymap.set('n', '<C-j>', function() vim.cmd('silent! 2argument') end)
vim.keymap.set('n', '<C-k>', function() vim.cmd('silent! 3argument') end)
vim.keymap.set('n', '<C-n>', function() vim.cmd('silent! 4argument') end)
vim.keymap.set('n', '<C-m>', function() vim.cmd('silent! 5argument') end)

-- fzf keybindings
local fzf = require('fzf-lua')
vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<C-f>', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fg', fzf.git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>fc', fzf.git_commits, { desc = 'Git commits' })

-- Autocommands
vim.api.nvim_create_autocmd('FileType', {
	callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.o.signcolumn = 'yes:1'
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.o.complete = 'o,.,w,b,u'
			vim.o.completeopt = 'menu,menuone,popup,noinsert'
			vim.lsp.completion.enable(true, client.id, args.buf)
		end
	end
})

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.highlight.on_yank() end,
})

-- Neovide settings
if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0
	vim.o.guifont = "Iosevka"

	vim.keymap.set({'n','v'}, '<D-c>', '"+y')
	vim.keymap.set({'n','v'}, '<D-v>', '"+p')
	vim.keymap.set('i', '<D-v>', '<C-r>+')

	vim.keymap.set('n', '<D-=>', function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1 end)
	vim.keymap.set('n', '<D-->', function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1 end)
	vim.keymap.set('n', '<D-0>', function() vim.g.neovide_scale_factor = 1.0 end)
end
