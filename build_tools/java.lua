local java = {}

vim.cmd.cd('~/Documents/programming/dsa/')

vim.cmd.Oil()
vim.lsp.enable('jdtls')

-- Compile only
vim.api.nvim_create_user_command('J', function()
    local file = vim.fn.expand('%:t')
    local name = vim.fn.expand('%:t:r')
    -- Compile the file only
    vim.cmd('!javac ' .. vim.fn.shellescape(file))
end, {})

-- The ONE keymap you need: compile and run
vim.keymap.set('n', '<leader>r', function()
    local file = vim.fn.expand('%:t')
    local name = vim.fn.expand('%:t:r')
    vim.cmd('!javac ' .. file .. ' && java ' .. name)
end)

-- Run with input.txt
vim.keymap.set('n', '<leader>R', function()
    local name = vim.fn.expand('%:t:r')
    vim.cmd('!java ' .. name .. ' < input.txt')
end)

-- Format
vim.api.nvim_create_user_command('F', function()
    vim.lsp.buf.format()
end, {})

-- New problem from template
vim.api.nvim_create_user_command('New', function(opts)
    local name = opts.args ~= '' and opts.args or vim.fn.input('Class name: ')
    vim.cmd('edit ' .. name .. '.java')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        'public class ' .. name .. ' {',
        '    public static void main(String[] args) {',
        '    }',
        '}'
    })
    vim.cmd('normal! 2G$')  -- jump inside main
end, { nargs = '?' })
