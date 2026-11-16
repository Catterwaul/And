import And
import Testing

enum And_map_Tests {
  @Test static func map() {
    #expect(1&.map(-) == -1)
    #expect("🐈"&.map { "🏃 \($0)" } == "🏃 🐈")
    #expect(Object()&.map(\.cat) == "🐈")
    #expect(NonCopyableInt(2)&.map { $0.value * 3 } == 6)
  }

  // MARK: - Wrapped functions with a parameter

  @Test static func `map, with a wrapped function`() throws {
    let isEven = { (int: Int) in int.isMultiple(of: 2) }
    #expect([1, 2, 3, 4].filter(isEven&.map(!)) == [1, 3])

    let none = identity&.map { $0 + 1 }
    #expect(typeName(of: none) == "(Int) -> Int")
    #expect(none(1) == 2)

    let wrappedThrows = throwing(ErrorA(), unlessAbove: 0)&.map { $0 + 1 }
    #expect(typeName(of: wrappedThrows) == "(Int) throws(ErrorA) -> Int")
    #expect(try wrappedThrows(1) == 2)
    #expect(throws: ErrorA()) { try wrappedThrows(0) }
  }

  @Test static func `map, with a wrapped function with a noncopyable parameter`() {
    #expect(increment&.map { $0.value * 2 }(.init(1)) == 4)
  }

  @Test static func `map, with a wrapped function that doesn't throw`() throws {
    let transformThrows = identity&.map(throwing(ErrorB(), unlessAbove: 1))
    #expect(typeName(of: transformThrows) == "(__owned Int) throws(ErrorB) -> Int")
    #expect(try transformThrows(2) == 2)
    #expect(throws: ErrorB()) { try transformThrows(1) }

    #expect(try increment&.map(throwingNonCopyable(ErrorB(), unlessAbove: 1))(.init(1)).value == 2)
  }

  @Test static func `map, with a wrapped function that throws the same error`() throws {
    let sameError = throwing(ErrorA(), unlessAbove: 0)&.map(throwing(ErrorA(), unlessAbove: 1))
    #expect(typeName(of: sameError) == "(__owned Int) throws(ErrorA) -> Int")
    #expect(try sameError(2) == 2)
    #expect(throws: ErrorA()) { try sameError(0) }
    #expect(throws: ErrorA()) { try sameError(1) }

    let sameNonCopyableError = throwingNonCopyable(ErrorA(), unlessAbove: 0)&.map(throwingNonCopyable(ErrorA(), unlessAbove: 1))
    #expect(try sameNonCopyableError(.init(2)).value == 2)
  }

  @Test static func `map, with a wrapped function that throws a different error`() throws {
    let differentErrors = throwing(ErrorA(), unlessAbove: 0)&.map(throwing(ErrorB(), unlessAbove: 1))
    #expect(typeName(of: differentErrors) == "(__owned Int) throws -> Int")
    #expect(try differentErrors(2) == 2)
    #expect(throws: ErrorA()) { try differentErrors(0) }
    #expect(throws: ErrorB()) { try differentErrors(1) }

    let differentNonCopyableErrors = throwingNonCopyable(ErrorA(), unlessAbove: 0)&.map(throwingNonCopyable(ErrorB(), unlessAbove: 1))
    #expect(try differentNonCopyableErrors(.init(2)).value == 2)
  }

  // MARK: - Wrapped functions without parameters

  @Test static func `map, with a wrapped function without parameters`() throws {
    let none = noThrow&.map { $0 + 1 }
    #expect(typeName(of: none) == "() -> Int")
    #expect(none() == 2)

    let wrappedThrows = succeeding&.map { $0 + 1 }
    #expect(typeName(of: wrappedThrows) == "() throws(ErrorA) -> Int")
    #expect(try wrappedThrows() == 4)
    #expect(throws: ErrorA()) { try failing&.map { $0 + 1 }() }

    #expect(noThrowNonCopyable&.map { $0.value + 1 }() == 2)
  }

  @Test static func `map, with a wrapped function without parameters that doesn't throw`() throws {
    let transformThrows = noThrow&.map(throwing(ErrorB(), unlessAbove: 1))
    #expect(typeName(of: transformThrows) == "() throws(ErrorB) -> Int")
    #expect(try noThrow&.map(throwing(ErrorB(), unlessAbove: 0))() == 1)
    #expect(throws: ErrorB()) { try transformThrows() }

    #expect(try noThrowNonCopyable&.map(throwingNonCopyable(ErrorB(), unlessAbove: 0))().value == 1)
  }

  @Test static func `map, with a wrapped function without parameters that throws the same error`() throws {
    let sameError = succeeding&.map(throwing(ErrorA(), unlessAbove: 0))
    #expect(typeName(of: sameError) == "() throws(ErrorA) -> Int")
    #expect(try sameError() == 3)
    #expect(throws: ErrorA()) { try failing&.map(throwing(ErrorA(), unlessAbove: 0))() }
    #expect(throws: ErrorA()) { try succeeding&.map(throwing(ErrorA(), unlessAbove: 3))() }

    #expect(try succeedingNonCopyable&.map(throwingNonCopyable(ErrorA(), unlessAbove: 0))().value == 3)
  }

  @Test static func `map, with a wrapped function without parameters that throws a different error`() throws {
    let differentErrors = succeeding&.map(throwing(ErrorB(), unlessAbove: 0))
    #expect(typeName(of: differentErrors) == "() throws -> Int")
    #expect(try differentErrors() == 3)
    #expect(throws: ErrorA()) { try failing&.map(throwing(ErrorB(), unlessAbove: 0))() }
    #expect(throws: ErrorB()) { try succeeding&.map(throwing(ErrorB(), unlessAbove: 3))() }

    #expect(try succeedingNonCopyable&.map(throwingNonCopyable(ErrorB(), unlessAbove: 0))().value == 3)
  }
}

private struct ErrorA: Error, Equatable { }
private struct ErrorB: Error, Equatable { }

private func typeName<T>(of _: T) -> String { "\(T.self)" }

/// A function that throws `error` for any `Int` that isn't greater than `minimum`.
private func throwing<Error: Swift.Error>(
  _ error: Error,
  unlessAbove minimum: Int
) -> (Int) throws(Error) -> Int {
  { (int: Int) throws(Error) in
    guard int > minimum else { throw error }
    return int
  }
}

/// `throwing`, for a noncopyable `Int`.
private func throwingNonCopyable<Error: Swift.Error>(
  _ error: Error,
  unlessAbove minimum: Int
) -> (consuming NonCopyableInt) throws(Error) -> NonCopyableInt {
  { (int: consuming NonCopyableInt) throws(Error) in
    guard int.value > minimum else { throw error }
    return int
  }
}

private func identity(_ int: Int) -> Int { int }
private func increment(_ int: consuming NonCopyableInt) -> NonCopyableInt { .init(int.value + 1) }
private func noThrowNonCopyable() -> NonCopyableInt { .init(1) }
private func succeedingNonCopyable() throws(ErrorA) -> NonCopyableInt { .init(3) }
private func noThrow() -> Int { 1 }
private func succeeding() throws(ErrorA) -> Int { 3 }
private func failing() throws(ErrorA) -> Int { throw ErrorA() }
