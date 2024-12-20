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
    var size: MarkdownImageSize? {
        switch self {
            case .text(let input):
                let pattern = "\\{(?:width\\s*=\\s*(\\d+)px\\s*)?(?:height\\s*=\\s*(\\d+)px\\s*)?(?:width\\s*=\\s*(\\d+)px\\s*)?(?:height\\s*=\\s*(\\d+)px\\s*)?\\}"

                guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                    return nil
                }

                let range = NSRange(input.startIndex..<input.endIndex, in: input)
                guard let match = regex.firstMatch(in: input, options: [], range: range) else {
                    return nil
                }

                var width: CGFloat?
                var height: CGFloat?

                if let widthRange = Range(match.range(at: 1), in: input), let widthValue = Int(input[widthRange]) {
                    width = CGFloat(widthValue)
                } else if let widthRange = Range(match.range(at: 3), in: input), let widthValue = Int(input[widthRange]) {
                    width = CGFloat(widthValue)
                }

                if let heightRange = Range(match.range(at: 2), in: input), let heightValue = Int(input[heightRange]) {
                    height = CGFloat(heightValue)
                } else if let heightRange = Range(match.range(at: 4), in: input), let heightValue = Int(input[heightRange]) {
                    height = CGFloat(heightValue)
                }

                return MarkdownImageSize(width: width, height: height)
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
