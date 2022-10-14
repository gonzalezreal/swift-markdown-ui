import SwiftUI

struct ImageParagraph: BlockContent {
  private struct _View: View {
    @Environment(\.imageTransaction) private var imageTransaction
    @Environment(\.theme.paragraphSpacing) private var paragraphSpacing

    private let imageInlines: [Numbered<ImageInline>]

    init(_ imageInlines: [ImageInline]) {
      self.imageInlines = imageInlines.numbered()
    }

    var body: some View {
      FlowLayout(imageInlines, id: \.number, spacing: 8, transaction: imageTransaction) {
        $0.element
      }
      .preference(key: SpacingPreference.self, value: paragraphSpacing)
    }
  }

  let imageInlines: [ImageInline]

  func render() -> some View {
    _View(imageInlines)
  }
}

extension ImageParagraph {
  init?(inlines: [Inline]) {
    var imageInlines: [ImageInline] = []
    for inline in inlines {
      switch inline {
      case .softBreak, .lineBreak:
        continue
      case let .image(.some(source), _, children):
        imageInlines.append(.image(.init(url: URL(string: source), alt: children.text)))
      case let .link(destination, children):
        guard children.count == 1,
          case let .image(.some(source), _, children) = children.first
        else {
          return nil
        }
        imageInlines.append(
          .link(
            .init(
              url: destination.flatMap(URL.init(string:)),
              content: .init(url: URL(string: source), alt: children.text)
            )
          )
        )
      default:
        return nil
      }
    }
    self.init(imageInlines: imageInlines)
  }
}
