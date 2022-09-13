import Foundation

internal struct Indexed<Index, Value> {
  var index: Index
  var value: Value
}

extension Indexed: Equatable where Index: Equatable, Value: Equatable {
}

extension Indexed: Hashable where Index: Hashable, Value: Hashable {
}

extension Collection {
  internal func indexed() -> [Indexed<Index, Element>] {
    zip(indices, self).map(Indexed.init)
  }
}
