--------------------------------------------------------------------------------
-- Copyright (c) 2013 Sierra Wireless and others.
-- All rights reserved. This program and the accompanying materials
-- are made available under the terms of the Eclipse Public License v1.0
-- which accompanies this distribution, and is available at
-- http://www.eclipse.org/legal/epl-v10.html
--
-- Contributors:
--     Sierra Wireless - initial API and implementation
--------------------------------------------------------------------------------
local formatter =  require 'formatter'
local string =     require 'string'
local diff = require 'diff'

local M = {}
function M.test(luainputpath, luareferencepath)

	-- Load provided source
	local luafile, errormessage = io.open(luainputpath, 'r')
	assert(
		luafile,
		string.format('Unable to read from %s.\n%s', luainputpath, errormessage or '')
	)
	local luasource = luafile:read('*a')
	luafile:close()

	-- Format code
	local formattedCode = formatter.indentcode(luasource, '\n', true, '    ')
	assert(
		formattedCode,
		string.format('Unable to format %s.\n', luainputpath)
	)

	-- Load provided reference
	local referenceFile, errormessage = io.open(luareferencepath)
	assert(
		referenceFile,
		string.format('Unable to read reference from %s.\n%s', luareferencepath, errormessage or '')
	)
	local referenceCode = referenceFile:read('*a')
	if referenceCode ~= formattedCode then
    return nil, string.format('Formatting Error:\%s',
      diff(referenceCode, formattedCode):format_as_text())
	end
	return true
end
return M
