import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct ImageFlow: View {
  private enum Item: Hashable {
    case image(source: String?, alt: String, destination: String? = nil)
    case lineBreak
  }

  @State private var spacing = ImageSpacing(horizontal: 0, vertical: 0)

  private let items: [Indexed<Item>]

  var body: some View {
    Flow(horizontalSpacing: self.spacing.horizontal, verticalSpacing: self.spacing.vertical) {
      ForEach(self.items, id: \.self) { item in
        switch item.value {
        case let .image(source, alt, destination):
          ImageView(source: source, alt: alt, destination: destination)
        case .lineBreak:
          Spacer()
        }
      }
    }
    .onImageSpacingChange { spacing in
      self.spacing = spacing
    }
  }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ImageFlow {
  init?(_ inlines: [Inline]) {
    var items: [Item] = []

    for inline in inlines {
      switch inline {
      case let .text(text) where text.isEmpty:
        continue
      case .softBreak:
        continue
      case .lineBreak:
        items.append(.lineBreak)
      case let .image(source, children):
        items.append(.image(source: source, alt: children.text))
      case let .link(destination, children) where children.count == 1:
        guard let (source, alt) = children.first?.image else {
          return nil
        }
        items.append(.image(source: source, alt: alt, destination: destination))
      default:
        return nil
      }
    }

    self.items = items.indexed()
  }
}