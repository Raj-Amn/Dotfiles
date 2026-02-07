-- java.lua - Java project helper extension
local M = {}
local terminal = require('terminal')

-- Attach a Java development environment
-- Opens a terminal with Java/Maven/Gradle setup
function M.attach(opts)
    opts = opts or {}
    local java_version = opts.java_version or '17'
    
    -- Build environment setup command
    local env_command = ''
    
    -- Setup JAVA_HOME if specified
    if opts.java_home then
        env_command = string.format(
            'export JAVA_HOME=%s; export PATH=$JAVA_HOME/bin:$PATH',
            opts.java_home
        )
    end
    
    -- Combine with user command if provided
    local full_command = opts.command
        and (env_command ~= '' and (env_command .. '; ' .. opts.command) or opts.command)
        or (env_command ~= '' and env_command or nil)
    
    return terminal.attach {
        program = opts.program,
        command = full_command,
        hide = opts.hide
    }
end

-- Configure make command and error format for Java compilation
M.make = function(opts)
    opts = opts or {}
    local build_tool = opts.build_tool or 'maven'
    
    -- Set makeprg based on build tool
    if build_tool == 'maven' then
        vim.opt.makeprg = opts.command or 'mvn compile'
    elseif build_tool == 'gradle' then
        vim.opt.makeprg = opts.command or './gradlew build'
    else
        vim.opt.makeprg = opts.command or 'javac %'
    end
    
    vim.opt.errorformat = {
        -- javac error format
        '%E%f:%l: error: %m',
        '%W%f:%l: warning: %m',
        '%A%f:%l: %m',
        '%C%m',
        -- Maven/Gradle error format
        '%E[ERROR] %f:[%l,%c] %m',
        '%W[WARNING] %f:[%l,%c] %m',
        '%E[ERROR] %m',
        '%W[WARNING] %m',
        -- Compilation failure
        '%E[ERROR] COMPILATION ERROR :',
        '%E[ERROR] Failed to execute goal %m',
        -- Stack traces
        '%C%.%#Exception: %m',
        '%C%\\s%#at %m',
        '%C%\\s%#... %m',
        '%C%\\s%#Caused by: %m',
        -- Ignore
        '%-G%.%#'
    }
    vim.cmd.make()
end

-- Configure LSP for Java
function M.setup_lsp(opts)
    opts = opts or {}
    local lsp_server = opts.server or 'jdtls'
    
    if lsp_server == 'jdtls' then
        vim.lsp.enable('jdtls')
    end
end

return M
