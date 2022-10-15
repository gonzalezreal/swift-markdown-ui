import Foundation

struct Identified<ID: Hashable, Value>: Identifiable {
  let id: ID
  var value: Value

  init(_ value: Value, id: ID) {
    self.id = id
    self.value = value
  }
}

extension Identified: Equatable where Value: Equatable {}

extension Identified: Hashable where Value: Hashable {}

extension Sequence where Element: Hashable {
  func identified() -> [Identified<Int, Element>] {
    zip(0..., self)
      .map { position, item in
        var hasher = Hasher()
        hasher.combine(position)
        hasher.combine(item)
        return Identified(item, id: hasher.finalize())
      }
  }
}
