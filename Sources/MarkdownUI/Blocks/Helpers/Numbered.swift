import Foundation

@dynamicMemberLookup
struct Numbered<Element> {
  var number: Int
  var element: Element

  subscript<T>(dynamicMember keyPath: WritableKeyPath<Element, T>) -> T {
    get { element[keyPath: keyPath] }
    set { element[keyPath: keyPath] = newValue }
  }
}

extension Numbered: Equatable where Element: Equatable {}
extension Numbered: Hashable where Element: Hashable {}

extension Numbered: Identifiable where Element: Identifiable {
  var id: Element.ID { element.id }
}

extension Sequence {
  func numbered(startingAt start: Int = 0) -> [Numbered<Element>] {
    zip(start..., self)
      .map { Numbered(number: $0.0, element: $0.1) }
  }
}
