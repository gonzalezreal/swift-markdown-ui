import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct ImageFlow: View {
  private enum Constants {
    static let spacing: Size = .rem(0.25)
    static let verticalSpacing: Size = .rem(0.25)
  }

  private enum Item: Hashable {
    case image(source: String?, alt: String, destination: String? = nil)
    case lineBreak
  }

  @Environment(\.fontStyle) private var fontStyle

  private let items: [Indexed<Item>]

  private var spacing: CGFloat {
    Size.rem(0.25).points(relativeTo: self.fontStyle)
  }

  var body: some View {
    FlowLayout(horizontalSpacing: self.spacing, verticalSpacing: self.spacing) {
      ForEach(self.items, id: \.self) { item in
        switch item.value {
        case let .image(source, alt, destination):
          ImageView(source: source, alt: alt, destination: destination)
        case .lineBreak:
          Spacer()
        }
      }
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
