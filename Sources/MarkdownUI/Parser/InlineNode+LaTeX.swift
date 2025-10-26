import Foundation

private enum LaTeXRegex {
  static let display = try! NSRegularExpression(pattern: #"\\\[(.*?)\\\]"#, options: [.dotMatchesLineSeparators])
  static let inline = try! NSRegularExpression(pattern: #"\\\((.*?)\\\)"#, options: [])
}

extension Sequence where Element == InlineNode {
  func extractingLaTeX() -> [InlineNode] {
    self.flatMap { $0.extractingLaTeX() }
  }
}

extension InlineNode {
  func extractingLaTeX() -> [InlineNode] {
    switch self {
    case .text(let content):
      return extractLaTeXFromText(content)
    case .emphasis(let children):
      return [.emphasis(children: children.extractingLaTeX())]
    case .strong(let children):
      return [.strong(children: children.extractingLaTeX())]
    case .strikethrough(let children):
      return [.strikethrough(children: children.extractingLaTeX())]
    case .link(let destination, let children):
      return [.link(destination: destination, children: children.extractingLaTeX())]
    default:
      return [self]
    }
  }

  private func extractLaTeXFromText(_ text: String) -> [InlineNode] {
    var result: [InlineNode] = []
    var lastIndex = text.startIndex

    let nsText = text as NSString
    let fullRange = NSRange(location: 0, length: nsText.length)

    var matches: [(range: NSRange, latex: String, isDisplay: Bool)] = []

    LaTeXRegex.display.enumerateMatches(in: text, options: [], range: fullRange) { match, _, _ in
      guard let match = match, match.numberOfRanges >= 2 else { return }
      let contentRange = match.range(at: 1)
      if let swiftRange = Range(contentRange, in: text) {
        matches.append((range: match.range, latex: String(text[swiftRange]), isDisplay: true))
      }
    }

    LaTeXRegex.inline.enumerateMatches(in: text, options: [], range: fullRange) { match, _, _ in
      guard let match = match, match.numberOfRanges >= 2 else { return }
      let contentRange = match.range(at: 1)

      let overlaps = matches.contains { existing in
        NSIntersectionRange(existing.range, match.range).length > 0
      }

      if !overlaps, let swiftRange = Range(contentRange, in: text) {
        matches.append((range: match.range, latex: String(text[swiftRange]), isDisplay: false))
      }
    }

    matches.sort { $0.range.location < $1.range.location }

    for match in matches {
      guard let swiftRange = Range(match.range, in: text) else { continue }

      if lastIndex < swiftRange.lowerBound {
        let textContent = String(text[lastIndex..<swiftRange.lowerBound])
        if !textContent.isEmpty {
          result.append(.text(textContent))
        }
      }

      result.append(.latex(match.latex, isDisplay: match.isDisplay))
      lastIndex = swiftRange.upperBound
    }

    if lastIndex < text.endIndex {
      let remainingText = String(text[lastIndex...])
      if !remainingText.isEmpty {
        result.append(.text(remainingText))
      }
    }

    return result.isEmpty ? [.text(text)] : result
  }
}
