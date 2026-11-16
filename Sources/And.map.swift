public extension And where Value: ~Copyable {
  /// Passes the wrapped value to a function.
  /// - Parameter transform: Takes ownership of the wrapped value.
  /// - Returns: What `transform` returns.
  /// - Throws: What `transform` throws.
  @inlinable consuming func map<Transformed: ~Copyable, Error>(
    _ transform: (consuming Value) throws(Error) -> Transformed
  ) throws(Error) -> Transformed {
    try transform(value)
  }

  // MARK: - Compose the wrapped function with a transform of its result
  // The overloads differ in whether the wrapped function and the `transform` throw.
  // When neither throws, all of them apply, so the ones for a `transform` that throws are disfavored.

  /// Composes the wrapped function with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: Doesn't throw.
  /// - Returns: A function that throws what the wrapped function throws.
  /// - Attention: When neither the wrapped function nor the transform throws, this overload is the one that is chosen.
  @inlinable func map<A: ~Copyable, B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) -> C
  ) -> (consuming A) throws(Error) -> C
  where Value == (consuming A) throws(Error) -> B {
    { try value($0)&.map(transform) }
  }

  /// Composes the wrapped function with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw.
  /// - Returns: A function that throws what `transform` throws, because the wrapped function doesn't throw.
  @_disfavoredOverload @inlinable func map<A: ~Copyable, B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) throws(Error) -> C
  ) -> (consuming A) throws(Error) -> C
  where Value == (consuming A) -> B {
    { try transform(value($0)) }
  }

  /// Composes the wrapped function with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw the same type of error that the wrapped function does.
  /// - Returns: A function that throws that type of error.
  @_disfavoredOverload @inlinable func map<A: ~Copyable, B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) throws(Error) -> C
  ) -> (consuming A) throws(Error) -> C
  where Value == (consuming A) throws(Error) -> B {
    { try transform(value($0)) }
  }

  /// Composes the wrapped function with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw a different type of error than the wrapped function does.
  /// - Returns: A function that can throw either type of error, so it throws `any Error`.
  @_disfavoredOverload @inlinable func map<A: ~Copyable, B: ~Copyable, C: ~Copyable, Error0, Error1>(
    _ transform: @escaping (consuming B) throws(Error1) -> C
  ) -> (consuming A) throws -> C
  where Value == (consuming A) throws(Error0) -> B {
    { try transform(value($0)) }
  }

  // MARK: - No parameters

  /// Composes the wrapped function, which has no parameters, with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: Doesn't throw.
  /// - Returns: A function that throws what the wrapped function throws.
  /// - Attention: When neither the wrapped function nor the transform throws, this overload is the one that is chosen.
  @inlinable func map<B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) -> C
  ) -> () throws(Error) -> C
  where Value == () throws(Error) -> B {
    { try value()&.map(transform) }
  }

  /// Composes the wrapped function, which has no parameters, with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw.
  /// - Returns: A function that throws what `transform` throws, because the wrapped function doesn't throw.
  @_disfavoredOverload @inlinable func map<B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) throws(Error) -> C
  ) -> () throws(Error) -> C
  where Value == () -> B {
    { try value()&.map(transform) }
  }

  /// Composes the wrapped function, which has no parameters, with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw the same type of error that the wrapped function does.
  /// - Returns: A function that throws that type of error.
  @_disfavoredOverload @inlinable func map<B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) throws(Error) -> C
  ) -> () throws(Error) -> C
  where Value == () throws(Error) -> B {
    { try transform(value()) }
  }

  /// Composes the wrapped function, which has no parameters, with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: May throw a different type of error than the wrapped function does.
  /// - Returns: A function that can throw either type of error, so it throws `any Error`.
  @_disfavoredOverload @inlinable func map<B: ~Copyable, C: ~Copyable, Error0, Error1>(
    _ transform: @escaping (consuming B) throws(Error1) -> C
  ) -> () throws -> C
  where Value == () throws(Error0) -> B {
    { try transform(value()) }
  }
}

// MARK: - Copyable parameter
public extension And {
  /// Composes the wrapped function with a function that transforms its result.
  ///
  /// The returned function calls the wrapped function, then passes the result to `transform`.
  /// - Parameter transform: Doesn't throw.
  /// - Returns: A function that throws what the wrapped function throws.
  /// - Attention: When the wrapped function's parameter is `Copyable`, this overload is chosen over the one
  ///   for any parameter, so that the returned function takes an ordinary parameter, not a `consuming` one.
  ///   That keeps it from needing a conversion, when it's used as a function with an ordinary parameter.
  @inline(__always) @inlinable func map<A, B: ~Copyable, C: ~Copyable, Error>(
    _ transform: @escaping (consuming B) -> C
  ) -> (A) throws(Error) -> C
  where Value == (A) throws(Error) -> B {
    { try value($0)&.map(transform) }
  }
}
