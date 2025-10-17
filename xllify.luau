-- xllify core library
local xllify = {}
local registeredFunctions = {}

-- Register an Excel function
xllify.ExcelFunction = function(metadata, func)
	local name = metadata.name
	if name then
		registeredFunctions[name] = {
			metadata = metadata,
			func = func
		}
	end
	return true
end

-- Helper function to check if value is a 1D table/array
local function is1DArray(value)
	if type(value) ~= "table" then
		return false
	end
	if #value == 0 then
		return false
	end
	-- Check that no elements are tables themselves
	for i = 1, #value do
		if type(value[i]) == "table" then
			return false
		end
	end
	return true
end

-- Helper function to check if value is a 2D table/matrix
local function is2DArray(value)
	if type(value) ~= "table" then
		return false
	end
	if #value == 0 then
		return false
	end
	for i = 1, #value do
		if type(value[i]) ~= "table" then
			return false
		end
	end
	return true
end

-- Helper function to convert column number to Excel-style letter
local function colToLetter(col)
	local letter = ""
	while col > 0 do
		local remainder = (col - 1) % 26
		letter = string.char(65 + remainder) .. letter
		col = math.floor((col - 1) / 26)
	end
	return letter
end

-- Pretty print a 1D array/list with ANSI box drawing
local function printList(list)
	if #list == 0 then
		print("(empty list)")
		return
	end

	-- Calculate maximum value width
	local maxWidth = 5  -- Minimum width for "Index"
	for i = 1, #list do
		local value = list[i] or ""
		maxWidth = math.max(maxWidth, string.len(tostring(value)))
	end

	-- Calculate index column width
	local indexWidth = math.max(5, string.len(tostring(#list)))

	local function padCenter(str, width)
		local len = string.len(str)
		local leftPad = math.floor((width - len) / 2)
		local rightPad = width - len - leftPad
		return string.rep(" ", leftPad) .. str .. string.rep(" ", rightPad)
	end

	local function padRight(str, width)
		return str .. string.rep(" ", width - string.len(str))
	end

	-- Print top border
	print("┌─" .. string.rep("─", indexWidth) .. "─┬─" .. string.rep("─", maxWidth) .. "─┐")

	-- Print header
	print("│ " .. padCenter("Index", indexWidth) .. " │ " .. padCenter("Value", maxWidth) .. " │")

	-- Print header separator
	print("├─" .. string.rep("─", indexWidth) .. "─┼─" .. string.rep("─", maxWidth) .. "─┤")

	-- Print data rows
	for i = 1, #list do
		local value = list[i] or ""
		print("│ " .. padCenter(tostring(i), indexWidth) .. " │ " .. padRight(tostring(value), maxWidth) .. " │")
	end

	-- Print bottom border
	print("└─" .. string.rep("─", indexWidth) .. "─┴─" .. string.rep("─", maxWidth) .. "─┘")
end

-- Pretty print a 2D table with ANSI box drawing
local function printTable(matrix)
	if #matrix == 0 then
		print("(empty table)")
		return
	end

	local numCols = 0
	for _, row in ipairs(matrix) do
		numCols = math.max(numCols, #row)
	end

	-- Calculate column widths (including header column for row numbers)
	local colWidths = {}
	colWidths[0] = 3  -- Row number column

	-- Initialize with column header widths
	for col = 1, numCols do
		colWidths[col] = string.len(colToLetter(col))
	end

	-- Check data widths
	for rowIdx, row in ipairs(matrix) do
		colWidths[0] = math.max(colWidths[0], string.len(tostring(rowIdx)))
		for col = 1, numCols do
			local value = row[col] or ""
			colWidths[col] = math.max(colWidths[col], string.len(tostring(value)))
		end
	end

	-- Box drawing characters
	local function makeLine(left, mid, right, fill)
		local line = left
		line = line .. string.rep(fill, colWidths[0] + 2)
		for col = 1, numCols do
			line = line .. mid .. string.rep(fill, colWidths[col] + 2)
		end
		line = line .. right
		return line
	end

	local function padCenter(str, width)
		local len = string.len(str)
		local leftPad = math.floor((width - len) / 2)
		local rightPad = width - len - leftPad
		return string.rep(" ", leftPad) .. str .. string.rep(" ", rightPad)
	end

	local function padRight(str, width)
		return str .. string.rep(" ", width - string.len(str))
	end

	-- Print top border
	print(makeLine("┌", "┬", "┐", "─"))

	-- Print column headers
	local headerLine = "│ " .. padCenter("", colWidths[0]) .. " "
	for col = 1, numCols do
		headerLine = headerLine .. "│ " .. padCenter(colToLetter(col), colWidths[col]) .. " "
	end
	headerLine = headerLine .. "│"
	print(headerLine)

	-- Print header separator
	print(makeLine("├", "┼", "┤", "─"))

	-- Print data rows
	for rowIdx, row in ipairs(matrix) do
		local rowLine = "│ " .. padCenter(tostring(rowIdx), colWidths[0]) .. " "
		for col = 1, numCols do
			local value = row[col] or ""
			rowLine = rowLine .. "│ " .. padRight(tostring(value), colWidths[col]) .. " "
		end
		rowLine = rowLine .. "│"
		print(rowLine)
	end

	-- Print bottom border
	print(makeLine("└", "┴", "┘", "─"))
end

-- Call a registered function and pretty prints the result
xllify.Call = function(name, ...)
	local args = {...}
	local registered = registeredFunctions[name]

	if not registered then
		print("Error: Function '" .. name .. "' not found")
		return nil
	end

	-- Build the Call line for output
	local callLine = 'Running xllify.Call("' .. name .. '"'
	for i, arg in ipairs(args) do
		callLine = callLine .. ", "
		if type(arg) == "string" then
			callLine = callLine .. '"' .. arg .. '"'
		else
			callLine = callLine .. tostring(arg)
		end
	end
	callLine = callLine .. ")"

	-- Print the Call line as comment
	print("-- " .. callLine)

	-- Build Excel formula representation
	local formula = "=" .. name .. "("
	for i, arg in ipairs(args) do
		if type(arg) == "string" then
			formula = formula .. '"' .. arg .. '"'
		else
			formula = formula .. tostring(arg)
		end
		if i < #args then
			formula = formula .. ", "
		end
	end
	formula = formula .. ")"

	-- Print the Excel formula
	print("-- Excel: " .. formula)

	-- Execute the function and print result
	local result = registered.func(table.unpack(args))

	print("Rendered output:")
	-- Pretty print based on result type
	if is2DArray(result) then
		printTable(result)
	elseif is1DArray(result) then
		printList(result)
	else
		print(result)
		print("") -- Blank line after text result
	end

	return result
end

-- List all registered functions
xllify.List = function()
	print("\nRegistered functions:")
	print(string.rep("─", 50))
	local count = 0
	for name, registered in pairs(registeredFunctions) do
		count = count + 1
		local meta = registered.metadata
		print(string.format("  %-20s", name))
		if meta.description then
			print(string.format("    %s", meta.description))
		end
		if meta.parameters then
			local params = {}
			for _, param in ipairs(meta.parameters) do
				table.insert(params, param.name or "arg")
			end
			print(string.format("    Parameters: %s", table.concat(params, ", ")))
		end
		print("")
	end
	if count == 0 then
		print("  (no functions registered)")
	end
	print(string.rep("─", 50))
end

xllify.ls = xllify.List
xllify.call = xllify.Call
xllify.list = xllify.List

return xllify