# xllify CLI

A command-line interface for testing and interacting with xllify functions that can be used in Excel. The CLI provides an interactive shell and direct command execution for calling Luau-based functions with support for various data types. This is useful for testing functions out locally, with no other installation required.

## Features

- **Interactive Mode**: REPL-style interface with readline support (command history and line editing)
- **Direct Command Execution**: Execute commands directly from the command line
- **JSON Output**: Machine-readable output format for scripting and automation
- **Function Management**: List, describe, and call registered functions
- **Rich Data Types**: Support for numbers, strings, booleans, and multi-dimensional arrays
- **Excel Formula Preview**: See equivalent Excel formulas when calling functions

## Installation

Download from the [releases](https://github.com/acornsoftuk/xllify-local/releases/tag/v1.0.0) page.

## Usage

### Interactive Mode

Start the interactive shell:

```bash
xllify
```

Or load a Luau file on startup:

```bash
xllify --load functions.luau
```

### Direct Command Execution

Execute commands directly without entering interactive mode:

```bash
xllify list
xllify desc MyFunction
xllify call MyFunction 42 "hello"
```

### JSON Output

Get machine-readable output for scripting:

```bash
xllify --json list
xllify --json call Add 5 10
```

## Commands

### `list` (or `ls`)

List all registered functions with their descriptions.

**Interactive:**

```
> list
```

**Direct:**

```bash
xllify list
```

**JSON Output:**

```bash
xllify --json list
# Returns: [{"name":"FunctionName","description":"...","category":"..."}]
```

### `desc <function>` (or `describe`)

Show detailed information about a function including parameters, types, and usage examples.

**Interactive:**

```
> desc Add
```

**Direct:**

```bash
xllify desc Add
```

**Output includes:**

- Function name and description
- Category
- Parameter list with types and descriptions
- Usage examples for CLI and Excel

### `call <function> [args...]`

Execute a function with the provided arguments.

**Interactive:**

```
> call Add 5 10
Excel: =Add(5, 10)
       =XLLIFY("Add", 5, 10)

15.000000
```

**Direct:**

```bash
xllify call Add 5 10
```

**JSON Output:**

```bash
xllify --json call Add 5 10
# Returns: 15.0
```

### `load <file.luau>`

Load a Luau file containing function definitions.

**Interactive:**

```
> load functions.luau
Successfully loaded functions.luau
Total functions: 5
```

**Direct:**

```bash
xllify load functions.luau
```

### `help` (or `?`)

Display help information about available commands.

### `quit` (or `exit`, `q`)

Exit the interactive shell (interactive mode only).

## Argument Types

The CLI automatically parses arguments into appropriate types:

### Numbers

```bash
call MyFunction 42        # Integer
call MyFunction 3.14      # Float
call MyFunction -10       # Negative
```

### Strings

Enclose in double quotes:

```bash
call MyFunction "hello world"
call MyFunction "with \"quotes\""
```

### Booleans

```bash
call MyFunction true
call MyFunction false
```

### Mixed Arguments

```bash
call MyFunction 42 "text" true 3.14
```

## Output Formats

### Scalar Values

```
> call GetValue
42.000000
```

### Strings

```
> call GetName
"John Doe"
```

### Booleans

```
> call IsValid
true
```

### Multi-dimensional Arrays (Matrices)

The CLI displays arrays in a formatted table with column labels (A, B, C...) and row numbers:

```
> call GetMatrix
Matrix (3x3):
     A       B       C
   ┌────────┬────────┬────────┐
 1 │ 1.000  │ 2.000  │ 3.000  │
   ├────────┼────────┼────────┤
 2 │ 4.000  │ 5.000  │ 6.000  │
   ├────────┼────────┼────────┤
 3 │ 7.000  │ 8.000  │ 9.000  │
   └────────┴────────┴────────┘
```

### JSON Output

All values are converted to JSON format:

```bash
xllify --json call GetMatrix
# Returns: [[1.0,2.0,3.0],[4.0,5.0,6.0],[7.0,8.0,9.0]]
```

**JSON Types:**

- Numbers: `42.5`
- Strings: `"text"`
- Booleans: `true`, `false`
- Null/Nil: `null`
- Arrays: `[[1,2],[3,4]]`
- Errors: `{"error":"error_code_X"}` or `{"error":"message"}`
- Special numbers: `"Infinity"`, `"-Infinity"`, `null` (for NaN)

## Options

### `--load <file.luau>`

Load a Luau file before starting interactive mode or executing a command.

```bash
xllify --load functions.luau
xllify --load functions.luau call MyFunction 42
```

### `--json`

Output results in JSON format (non-interactive mode only).

```bash
xllify --json list
xllify --json call Add 5 10
```

### `--help`, `-h`

Display help information and exit.

```bash
xllify --help
```

## Examples

### Interactive Session

```bash
$ xllify
xllify CLI v1.0.0
Type 'help' for available commands

Loaded 12 functions

> list
Registered functions:
  Add - Add two numbers
  Multiply - Multiply two numbers
  FormatText - Format text with template
  ...

> desc Add
Function: Add
Description: Add two numbers
Category: Math

Parameters:
  1. a (number) - First number
  2. b (number) - Second number

Usage:
  CLI: call Add <a> <b>
  Excel: =Add(<arg1>, <arg2>)
         =XLLIFY("Add", <arg1>, <arg2>)

> call Add 5 10
Excel: =Add(5, 10)
       =XLLIFY("Add", 5, 10)

15.000000

> quit
```

### Automated Scripting

```bash
# Load functions and call in one command
xllify --load mylib.luau call ProcessData 100

# Get JSON output for parsing
result=$(xllify --json --load mylib.luau call Calculate 42)
echo $result | jq .

# List all functions in JSON
xllify --json list | jq '.[] | select(.category=="Math")'
```

## Platform Support

- **macOS**: Full readline support with editline
- **Windows**: Basic line editing (no readline history)

## Error Handling

The CLI provides clear error messages:

```
> call NonExistent
Function not found: NonExistent

> desc
Usage: desc <function_name>

> call Add 5
# Executes with provided arguments (functions handle missing params)
```

In JSON mode, errors are returned as JSON objects:

```bash
xllify --json call NonExistent
# Returns: {"error":"Function not found"}
```

## Exit Codes

- `0`: Success
- `1`: Error (function not found, invalid arguments, execution error, etc.)

## Tips

1. **Use Tab Completion**: On macOS/Linux, readline provides command history navigation with up/down arrows
2. **JSON for Scripts**: Use `--json` flag when calling from scripts for easier parsing
3. **Pre-load Functions**: Use `--load` to automatically load your function library
4. **Test Before Excel**: Use the CLI to test and debug functions before using them in Excel
5. **Check Function Signatures**: Use `desc` to see parameter types and descriptions
