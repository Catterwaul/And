struct NonCopyableInt: ~Copyable {
  var value: Int
  init(_ value: Int) { self.value = value }
}
