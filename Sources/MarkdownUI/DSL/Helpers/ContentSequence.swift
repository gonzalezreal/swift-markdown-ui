import Foundation

public struct _ContentSequence<Element> {
  let items: [Element]

  init(_ items: [Element]) {
    self.items = items
  }
}
