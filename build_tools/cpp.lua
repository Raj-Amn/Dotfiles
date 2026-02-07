local cpp = require('cpp')

vim.cmd.cd('~/Documents/programming/dsa/')

cpp.attach { hide = true }

vim.cmd.Oil()
vim.lsp.enable('clangd')
-- Compile only
vim.api.nvim_create_user_command('C', function()
    local file = vim.fn.expand('%:t')
    local name = vim.fn.expand('%:t:r')
    -- Compile the file only
    vim.cmd('!g++ -std=c++20 -O2 ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(name))
end, {})


-- The ONE keymap you need: compile and run
vim.keymap.set('n', '<leader>r', function()
    local file = vim.fn.expand('%:t')
    local name = vim.fn.expand('%:t:r')
    vim.cmd('!g++ -std=c++20 -O2 ' .. file .. ' -o ' .. name .. ' && ./' .. name)
end)

-- Run with input.txt
vim.keymap.set('n', '<leader>R', function()
    local name = vim.fn.expand('%:t:r')
    vim.cmd('!./' .. name .. ' < input.txt')
end)

-- Format
vim.api.nvim_create_user_command('F', function()
    vim.lsp.buf.format()
end, {})

-- New problem from template
vim.api.nvim_create_user_command('New', function(opts)
    local name = opts.args ~= '' and opts.args or vim.fn.input('Name: ')
    vim.cmd('edit ' .. name .. '.cpp')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        '#include <iostream>',
        '#include <vector>',
        '#include <algorithm>',
        'using namespace std;',
        '',
        'int main() {',
        '    ios_base::sync_with_stdio(false);',
        '    cin.tie(NULL);',
        '    ',
        '    return 0;',
        '}'
    })
    vim.cmd('normal! 9G$')
end, { nargs = '?' })

