-- cpp.lua - C++ project helper extension
local M = {}
local terminal = require('terminal')

-- Attach a C++ development environment
-- Opens a terminal with common C++ build tools
function M.attach(opts)
	opts = opts or {}
	local cxx_standard = opts.cxx_standard or '20'
	local build_type = opts.build_type or 'Debug'

	-- Build environment setup command
	local env_command = string.format(
		'export CXX_STANDARD=%s; export CMAKE_BUILD_TYPE=%s',
		cxx_standard,
		build_type
	)

	-- Combine with user command if provided
	local full_command = opts.command 
	and (env_command .. '; ' .. opts.command)
	or env_command

	return terminal.attach {
		program = opts.program,
		command = full_command,
		hide = opts.hide
	}
end

-- Configure make command and error format for C++ compilation
M.make = function(opts)
	opts = opts or {}
	vim.opt.makeprg = opts.command or 'cmake --build build'
	vim.opt.errorformat = {
		-- GCC/Clang error format
		"%f:%l:%c: %error: %m",
		"%f:%l:%c: %warning: %m",
		"%f:%l:%c: %note: %m",
		-- GCC/Clang with column range
		"%f:%l:%c-%k: %error: %m",
		"%f:%l:%c-%k: %warning: %m",
		-- MSVC error format
		"%f(%l): %error %m",
		"%f(%l): %warning %m",
		-- CMake errors
		"CMake Error at %f:%l %m",
		-- Linker errors
		"%D%*\\a[%*\\d]: Entering directory %*[`']%f",
		"%X%*\\a[%*\\d]: Leaving directory %*[`']%f",
		"%DMaking %*\\a in %f",
		"collect2: error: %m",
		-- Ignore
		"%-G%.%#"
	}
	vim.cmd.make()
end

-- Configure LSP for C++
function M.setup_lsp(opts)
	opts = opts or {}
	local lsp_server = opts.server or 'clangd'

	if lsp_server == 'clangd' then
		vim.lsp.enable('clangd')
	elseif lsp_server == 'ccls' then
		vim.lsp.enable('ccls')
	end
end

return M
