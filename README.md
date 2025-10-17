# xllify-local

## Getting setup

### Install luau

**macOS:**

```bash
# Using Homebrew
brew install luau

# Or download directly
curl -L https://github.com/luau-lang/luau/releases/latest/download/luau-macos -o luau
chmod +x luau
sudo mv luau /usr/local/bin/
```

**Linux:**

```bash
# Download the latest release
curl -L https://github.com/luau-lang/luau/releases/latest/download/luau-linux -o luau
chmod +x luau
sudo mv luau /usr/local/bin/

# Or using package managers (if available)
# Arch Linux
yay -S luau

# Ubuntu/Debian (via snap)
snap install luau
```

**Windows:**

```powershell
# Using Scoop
scoop install luau

# Or download directly from releases
# Visit: https://github.com/luau-lang/luau/releases
# Download luau-win.exe and rename to luau.exe
# Add to your PATH
```

### Installing xllify-local

Simply clone or download this repository:

```bash
git clone <repository-url>
cd xllify-local
```

## Usage

### Script

All of the examples in this README are in [readme.luau](./readme.luau). You can run it with `luau -i readme.luau`.

```lua
local xllify = require("./xllify")

-- Register a function
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
-- Output: Hello, World
```

## Function execution

### xllify.ExcelFunction(metadata, func)

Register a new Excel function.

**Parameters:**

- `metadata` (table): Function metadata
  - `name` (string): Function name
  - `description` (string, optional): Function description
  - `parameters` (array, optional): Array of parameter definitions
- `func` (function): The function implementation

**Example:**

```lua
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
```

### xllify.Call(name, ...)

Call a registered function with arguments. Results are automatically pretty-printed:

- Scalar values: printed as-is
- 1D arrays: displayed as indexed lists with borders
- 2D arrays: displayed as Excel-style tables with column letters

**Example:**

```lua
xllify.Call("MULTIPLY", 5, 3)
-- Output:
-- Running xllify.Call("MULTIPLY", 5, 3)
-- Excel: =MULTIPLY(5, 3)
-- 15
```

### xllify.List()

List all registered functions with their metadata.

**Example:**

```lua
xllify.List()
-- Output:
-- Registered functions:
--   GREET
--     Greets a person
--     Parameters: name
--   ...
```

### xllify.Help()

Display help information with all available commands and examples.

## REPL

For interactive development, you can load xllify modules into the Luau REPL and call functions directly. This is useful for testing and exploration.

```lua
> simple = require("./simple")
> simple.list()

Registered functions:
──────────────────────────────────────────────────
xllify.Demo.AgeCategory
Determines your life stage based on age
Parameters: age

xllify.Demo.Hello
Says hello!
Parameters: name

xllify.Demo.Portfolio
Generate sample portfolio holdings
Parameters: num_positions, total_value, seed

──────────────────────────────────────────────────

> simple.Call("xllify.Demo.Hello")
-- Running xllify.Call("xllify.Demo.Hello")
-- Excel: =xllify.Demo.Hello()
Hello, World!

> simple.Call("xllify.Demo.Portfolio")
-- Running xllify.Call("xllify.Demo.Portfolio")
-- Excel: =xllify.Demo.Portfolio()
┌─────┬───────┬──────┬────────────────────┬────────────────────┐
│     │   A   │  B   │         C          │         D          │
├─────┼───────┼──────┼────────────────────┼────────────────────┤
│  1  │ AAPL  │ 3355 │ 202.73256301879883 │ 680167.7489280701  │
│  2  │ MSFT  │ 3127 │ 50.96101760864258  │ 159355.10206222534 │
│  3  │ GOOGL │ 465  │ 228.82299423217773 │ 106402.69231796265 │
│  4  │ AMZN  │ 249  │ 104.61645126342773 │ 26049.496364593506 │
│  5  │ META  │ 134  │ 144.17943954467773 │ 19320.044898986816 │
│  6  │ TSLA  │ 18   │ 229.54320907592773 │ 4131.777763366699  │
│  7  │ NVDA  │ 14   │ 173.98900985717773 │ 2435.8461380004883 │
│  8  │ JPM   │ 6    │ 172.04809188842773 │ 1032.2885513305664 │
│  9  │ BAC   │ 0    │ 249.5017111301422  │ 0                  │
│ 10  │ XOM   │ 4    │ 85.69927215576172  │ 342.7970886230469  │
└─────┴───────┴──────┴────────────────────┴────────────────────┘
```
