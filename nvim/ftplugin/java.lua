vim.opt_local.makeprg = 'javac %'
vim.api.nvim_buf_create_user_command(0, 'C', 'make', {})
vim.api.nvim_buf_create_user_command(0, 'R', '!java -cp %:h %:t:r < input.txt', {})
