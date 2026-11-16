# ``And``

An affordance for adding extensions to every type.

The point of this package is to allow some way to add extensions that are suitable for every type, using dot syntax.

Much of it is about functions: wrap one in an ``And``, and `map` composes it with a transform of its result,
with the errors it can throw kept typed.

## Overview

### Composing functions

Append `&` to a function, and use `map` to transform what it returns. The result is a new function.

```swift
func isEven(_ int: Int) -> Bool { int.isMultiple(of: 2) }

[1, 2, 3, 4].filter(isEven&.map(!)) // [1, 3]
```

When a function throws a typed error, the composed function throws the same type, as long as the transform doesn't throw.

```swift
func parse(_ string: String) throws(ParseError) -> Int { … }

let double = parse&.map { $0 * 2 } // (String) throws(ParseError) -> Int
```

When the transform throws too, the composed function throws what the transform throws, if the wrapped function doesn't throw,
and the same type of error, if they both throw it.
If they throw different types of error, the composed function can throw either, so it throws `any Error`.

```swift
func requirePositive(_ int: Int) throws(RangeError) -> Int { … }

let parsePositive = parse&.map(requirePositive) // (String) throws -> Int
```

Functions that take no parameters can be composed in the same way,
and the functions, and their parameters and results, can be noncopyable.

### Usage Examples

You've got the source code, so aside from reading this documentation, see the **Tests** folder for example usage! 😺
