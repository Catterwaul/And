/// An affordance for adding extensions to every type.
///
/// You can't add extensions to `Any`.
/// The closest possible solution is to wrap a value in a type, and add extensions to that type.
///
/// This is that type.
///
/// - Remark: `And`'s initializer is not publicly useful. Use the `&` suffix to create one:
///
/// ```swift
/// let negativeOne = 1&.map(-)
/// ```
public struct And<Value> {
  @usableFromInline let value: Value
  @inlinable init(_ value: Value) { self.value = value }
}

postfix operator &
@inlinable public postfix func &<Value>(value: Value) -> And<Value> {
  .init(value)
}

public extension And {
  /// Apply a function to a mutable copy of the wrapped value.
  /// - Returns:A mutated copy of the wrapped value.
  @inlinable func apply<Error>(
    _ mutate: (inout Value) throws(Error) -> Void
  ) throws(Error) -> Value {
    var value = value
    try mutate(&value)
    return value
  }

  /// Transform the wrapped value.
  @inlinable func map<Transformed, Error>(
    _ transform: (Value) throws(Error) -> Transformed
  ) throws(Error) -> Transformed {
    try transform(value)
  }

  /// Transform the wrapped value if a condition is satisfied.
  @inlinable func or<Error>(
    if condition: Bool,
    _ transform: (Value) throws(Error) -> Value
  ) throws(Error) -> Value {
    condition ? try transform(value) : value
  }
}
