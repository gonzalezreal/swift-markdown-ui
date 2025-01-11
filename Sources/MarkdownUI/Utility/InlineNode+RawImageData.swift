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
                // Trying first to found a fixed pattern match
                let fixedPattern = "\\{(?:width\\s*=\\s*(\\d+)px\\s*)?(?:height\\s*=\\s*(\\d+)px\\s*)?(?:width\\s*=\\s*(\\d+)px\\s*)?(?:height\\s*=\\s*(\\d+)px\\s*)?\\}"

                if let (width, height) = extract(regexPattern: fixedPattern, from: input) {
                    return MarkdownImageSize(value: .fixed(width, height))
                }

                // Trying then to found a relative pattern match
                let relativePattern = "\\{(?:width\\s*=\\s*(\\d+)%\\s*)?(?:height\\s*=\\s*(\\d+)%\\s*)?(?:width\\s*=\\s*(\\d+)%\\s*)?(?:height\\s*=\\s*(\\d+)%\\s*)?\\}"

                if let (wRatio, hRatio) = extract(regexPattern: relativePattern, from: input) {
                    return MarkdownImageSize(value: .relative((wRatio ?? 100)/100, (hRatio ?? 100)/100))
                }

                return nil
            default:
                return nil
        }
    }

    private func extract(
        regexPattern pattern: String,
        from input: String
    ) -> (width: CGFloat?, height: CGFloat?)? {
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

        return (width, height)
    }
}

/// A value type representating an image size suffix.
///
/// Example:
///  - `![This is an image](https://foo/bar.png){width=50px}`
///  - `![This is an image](https://foo/bar.png){width=50%}`
///
/// Suffix can either be:
/// - `{width=50px}`
/// - `{height=50px}`
/// - `{width=50px height=100px}`
/// - `{height=50px width=100px}`
/// - `{width=50%}`
///
/// - Note: Relative height is not supported
struct MarkdownImageSize {
    let value: Value

    enum Value {
        /// Represents a fixed value size: `.fixed(width, height)`
        case fixed(CGFloat?, CGFloat?)
        /// Represents a relative value size: `.relative(relativeWidth, relativeHeight)`
        case relative(CGFloat, CGFloat)
    }
}
