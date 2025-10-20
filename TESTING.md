# xllify Test Framework

The xllify CLI includes a built-in test framework that allows you to write tests in Luau for your Excel functions.

## Quick Start

Create a test file (e.g., `my_tests.luau`):

```lua
xllify.TestSuite("My Function Tests", function()

    xllify.Test("should calculate correctly", function()
        local result = xllify.Call("MyFunction", 2, 3)
        xllify.Assert.Equal(5, result)
    end)

    xllify.Test("should handle matrices", function()
        local result = xllify.Call("Example.Matrix", 3, 3)
        xllify.Assert.IsMatrix(result)
        local dims = xllify.GetDimensions(result)
        xllify.Assert.Equal(3, dims[1])
        xllify.Assert.Equal(3, dims[2])
    end)

end)
```

Run the tests, specifying the script to load and then the test:

```bash
# Human-readable output
./xllify --load my_script.luau test my_tests.luau

# JSON output for scripting
./xllify --load my_script.luau --json test my_tests.luau

# JUnit XML output for CI/CD
./xllify --load my_script.luau --junit test my_tests.luau > test-results.xml
```

Multiple --load flags and Luau test files can be provided in one go.

## Test API

### Test Structure

- **`xllify.TestSuite(name, function)`** - Define a test suite

  ```lua
  xllify.TestSuite("Suite Name", function()
      -- tests go here
  end)
  ```

- **`xllify.Test(name, function)`** - Define an individual test
  ```lua
  xllify.Test("test name", function()
      -- test code here
  end)
  ```

### Calling Functions

- **`xllify.Call(functionName, ...args)`** - Call an Excel function
  ```lua
  local result = xllify.Call("Example.Matrix", 3, 3)
  local value = xllify.Call("MyFunction", "hello", 42, true)
  ```

### Assertions

- **`xllify.Assert.Equal(expected, actual)`** - Assert two values are equal

  - Works with: numbers, strings, booleans, matrices
  - For numbers, uses epsilon comparison (1e-9)

  ```lua
  xllify.Assert.Equal(5, result)
  xllify.Assert.Equal("hello", str_result)
  xllify.Assert.Equal(true, bool_result)
  ```

- **`xllify.Assert.IsMatrix(value)`** - Assert value is a matrix/array

  ```lua
  xllify.Assert.IsMatrix(result)
  ```

- **`xllify.Assert.Throws(function)`** - Assert function throws an error
  ```lua
  xllify.Assert.Throws(function()
      xllify.Call("FunctionThatErrors")
  end)
  ```

### Utilities

- **`xllify.GetDimensions(matrix)`** - Get matrix dimensions
  - Returns: `{rows, columns}` (1-indexed Lua table)
  ```lua
  local dims = xllify.GetDimensions(matrix)
  local rows = dims[1]
  local cols = dims[2]
  ```

## Output Formats

### Human-Readable (default)

```
Test Suite: Example Function Tests
==================================================

  ✓ Matrix should return correct dimensions (0ms)
  ✓ Matrix should contain correct values (0ms)
  ✗ This test failed (1ms)
    Error: Assertion failed: Expected 5 but got 3

==================================================
Tests: 3 | Passed: 2 | Failed: 1 | Duration: 1ms
```

Exit code: 0 if all pass, 1 if any fail

### JSON (`--json`)

```json
{
  "suite": "Example Function Tests",
  "passed": 2,
  "failed": 1,
  "total": 3,
  "duration": 1,
  "tests": [
    {
      "name": "Matrix should return correct dimensions",
      "passed": true,
      "duration": 0
    },
    {
      "name": "This test failed",
      "passed": false,
      "duration": 1,
      "error": "Assertion failed: Expected 5 but got 3"
    }
  ]
}
```

### JUnit XML (`--junit`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
  <testsuite name="Example Function Tests" tests="3" failures="1" errors="0" skipped="0" time="0.001">
    <testcase name="Matrix should return correct dimensions" classname="Example Function Tests" time="0" />
    <testcase name="This test failed" classname="Example Function Tests" time="0.001">
      <failure message="Assertion failed: Expected 5 but got 3">Assertion failed: Expected 5 but got 3</failure>
    </testcase>
  </testsuite>
</testsuites>
```

## CI/CD Integration

### GitHub Actions

The `--junit` flag outputs JUnit XML format that third party GitHub Actions can parse and display:

```yaml
- name: Run tests
  run: |
    ./xllify --junit test tests/*.luau > test-results.xml
```

## Suggested directory structure

```
my-project/
├── functions/
│   ├── math_functions.luau
│   └── string_functions.luau
└── tests/
    ├── test_math.luau
    ├── test_strings.luau
    └── test_integration.luau
```

```bash
./xllify --load functions/math_functions.luau test tests/test_math.luau
```
