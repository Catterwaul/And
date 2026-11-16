import And
import Testing

enum And_Tests {
  @Test static func `operator`() {
    #expect(()& is And<Void>)
    #expect(("🪉" as Optional).map(&) is And<String>)
  }

  @Test static func apply() {
    #expect(2&.apply { $0 *= 3 } == 6)
    #expect(Object()&.apply { $0.cat = "🐯" }.cat == "🐯")
  }
  
  @Test static func cast() {
    let value: Any = 0
    #expect(value&.cast() == 0)
    #expect(value&.cast() == Bool?.none)
  }

  @Test static func map() {
    do {
      // This is the example from `And`'s documentation.
      let negativeOne = 1&.map(-)

      #expect(negativeOne == -1)
    }

    #expect("🐈"&.map { "🏃 \($0)" } == "🏃 🐈")
    #expect(Object()&.map(\.cat) == "🐈")
  }

  @Test static func `or`() {
    var condition = false
    let pink = "🩷"
    let green = "💚"
    func makeItGreen(_: String) -> String { green }
    #expect(pink&.or(if: condition, makeItGreen) == pink)
    condition = true
    #expect(pink&.or(if: condition, makeItGreen) == green)
  }
}

private final class Object { var cat = "🐈" }
