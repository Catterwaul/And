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
public struct And<Value: ~Copyable>: ~Copyable {
  @usableFromInline let value: Value
  @inlinable init(_ value: consuming Value) { self.value = value }
}

postfix operator &
@inlinable public postfix func &<Value: ~Copyable>(value: consuming Value) -> And<Value> {
  .init(value)
}

public extension And where Value: ~Copyable {
  /// Apply a function to a mutable copy of the wrapped value.
  /// - Returns:A mutated copy of the wrapped value.
  @inlinable consuming func apply<Error>(
    _ mutate: (inout Value) throws(Error) -> Void
  ) throws(Error) -> Value {
    var value = value
    try mutate(&value)
    return value
  }
  
  /// Transform the wrapped value if a condition is satisfied.
  @inlinable consuming func or<Error>(
    if condition: Bool,
    _ transform: (consuming Value) throws(Error) -> Value
  ) throws(Error) -> Value {
    condition ? try transform(value) : value
  }
}

// MARK: Copyable
extension And: Copyable where Value: Copyable { }

public extension And {
  /// `as?`, but with an inferred return type.
  @inlinable func cast<Casted>() -> Casted? {
    value as? Casted
  }
}
