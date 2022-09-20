import SwiftUI

public struct _ListContentSequence<Element: ListContent>: ListContent {
  private let items: [Numbered<Element>]

  init(items: [Element]) {
    self.items = items.numbered()
  }

  public func makeBody(configuration: Configuration) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(items, id: \.number) { item in
        item.element
          .makeBody(configuration: configuration.at(index: item.number))
          .spacing(enabled: item.number < items.last!.number)
      }
    }
  }
}

extension ListContentConfiguration {
  fileprivate func at(index: Int) -> Self {
    var configuration = self
    configuration.listStart += index
    return configuration
  }
}
