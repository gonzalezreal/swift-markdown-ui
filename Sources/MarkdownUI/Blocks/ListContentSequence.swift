import SwiftUI

public struct _ListContentSequence<Element: ListContent>: ListContent {
  public var count: Int {
    items.count
  }

  private let items: [Numbered<Element>]

  init(items: [Element]) {
    self.items = items.numbered()
  }

  public func makeBody(number: Int, configuration: Configuration) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items, id: \.number) { item in
        item.element
          .makeBody(number: number + item.number, configuration: configuration)
          .spacing(enabled: item.number < items.last!.number)
      }
    }
  }
}
