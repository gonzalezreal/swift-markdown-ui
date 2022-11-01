import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct ImageParagraphView: View {
  private enum Item: Hashable {
    case image(source: String?, alt: String, destination: String? = nil)
    case lineBreak
  }

  @Environment(\.theme.paragraph) private var paragraph
  @State private var spacing = CGSize.zero

  private let items: [Identified<Int, Item>]

  var body: some View {
    self.paragraph.makeBody(.init(self.label))
  }

  @ViewBuilder private var label: some View {
    Flow(horizontalSpacing: self.spacing.width, verticalSpacing: self.spacing.height) {
      ForEach(self.items) { item in
        switch item.value {
        case let .image(source, alt, destination):
          ImageView(source: source, alt: alt, destination: destination)
        case .lineBreak:
          Spacer()
        }
      }
    }
    .onImageSpacingPreferenceChange { spacing in
      self.spacing = spacing
    }
  }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ImageParagraphView {
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

    self.items = items.identified()
  }
}
