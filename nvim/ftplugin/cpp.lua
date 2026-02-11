vim.opt_local.makeprg = 'g++ -Wall -Wextra -std=c++17 -O2 -o %:r %'
vim.api.nvim_buf_create_user_command(0, 'C', 'make', {})
vim.api.nvim_buf_create_user_command(0, 'R', '!./%:r < input.txt', {})
