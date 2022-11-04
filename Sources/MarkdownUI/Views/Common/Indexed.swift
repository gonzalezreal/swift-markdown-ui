import Foundation

struct Indexed<Value: Hashable>: Hashable {
  let index: Int
  let value: Value
}

extension Sequence where Element: Hashable {
  func indexed() -> [Indexed<Element>] {
    zip(0..., self).map { index, value in
      Indexed(index: index, value: value)
    }
  }
}
