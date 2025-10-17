local xllify = require("./xllify")

xllify.ExcelFunction({
  name = "GREET",
  description = "Greets a person",
  parameters = {
    {name = "name", description = "Name to greet"}
  }
}, function(name)
  return "Hello, " .. name
end)

-- Call the function
xllify.Call("GREET", "World")

xllify.ExcelFunction({
  name = "MULTIPLY",
  description = "Multiplies two numbers",
  parameters = {
    {name = "a", description = "First number"},
    {name = "b", description = "Second number"}
  }
}, function(a, b)
  return a * b
end)
xllify.Call("MULTIPLY", 5, 3)

xllify.ExcelFunction({
  name = "RANGE",
  description = "Creates a range of numbers"
}, function(start, stop)
  local result = {}
  for i = start, stop do
    table.insert(result, i)
  end
  return result
end)
xllify.Call("RANGE", 1, 5)

xllify.ExcelFunction({
  name = "MATRIX",
  description = "Creates a matrix"
}, function(rows, cols)
  local result = {}
  for i = 1, rows do
    result[i] = {}
    for j = 1, cols do
      result[i][j] = i * j
    end
  end
  return result
end)
xllify.Call("MATRIX", 3, 3)