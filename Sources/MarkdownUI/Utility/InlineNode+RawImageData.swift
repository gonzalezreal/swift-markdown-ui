import Foundation

struct RawImageData: Hashable {
  var source: String
  var alt: String
  var destination: String?
}

extension InlineNode {
  var imageData: RawImageData? {
    switch self {
    case .image(let source, let children):
      return .init(source: source, alt: children.renderPlainText())
    case .link(let destination, let children) where children.count == 1:
      guard var imageData = children.first?.imageData else { return nil }
      imageData.destination = destination
      return imageData
    default:
      return nil
    }
  }
}

extension InlineNode {
    @available(iOS 16.0, macOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var size: MarkdownImageSize? {
        switch self {
            case .text(let input):
                let pattern = /{(?:width\s*=\s*(\d+)px\s*)?(?:height\s*=\s*(\d+)px\s*)?(?:width\s*=\s*(\d+)px\s*)?(?:height\s*=\s*(\d+)px\s*)?\}/

                if let match = input.wholeMatch(of: pattern) {
                    let widthParts = [match.output.1, match.output.3].compactMap { $0 }
                    let heightParts = [match.output.2, match.output.4].compactMap { $0 }

                    let width = widthParts.compactMap { Float(String($0)) }.last
                    let height = heightParts.compactMap { Float(String($0)) }.last

                    return MarkdownImageSize(width: width.map(CGFloat.init), height: height.map(CGFloat.init))
                }

                return nil
            default:
                return nil
        }
    }
}

/// A value type representating an image size suffix.
///
/// Example: `![This is an image](https://foo/bar.png){width=50px}`
///
/// Suffix can be either
/// - {width=50px}
/// - {height=50px}
/// - {width=50px height=100px}
/// - {height=50px width=100px}
struct MarkdownImageSize {
    let width: CGFloat?
    let height: CGFloat?
}
