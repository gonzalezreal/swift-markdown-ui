import SwiftUI

public struct _ListContentSequence<Element: ListContent>: ListContent {
  private let items: [Numbered<Element>]

  init(items: [Element]) {
    self.items = items.numbered()
  }

  public func makeBody(configuration: Configuration) -> some View {
    VStack(alignment: .leading, spacing: configuration.spacing) {
      ForEach(items, id: \.number) { item in
        item.element.makeBody(configuration: configuration.at(index: item.number))
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
