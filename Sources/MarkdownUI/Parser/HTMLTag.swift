import Foundation

struct HTMLTag {
  let name: String
  let isClosing: Bool
  let isSelfClosing: Bool
  let href: String?
}

extension HTMLTag {
  private enum Constants {
    static let tagExpression = try! NSRegularExpression(pattern: "<\\/?([a-zA-Z0-9]+)[^>]*\\/?>")
    static let hrefExpression = try! NSRegularExpression(pattern: "\\bhref\\s*=\\s*[\"']([^\"']*)[\"']")
  }

  init?(_ description: String) {
    guard
      let match = Constants.tagExpression.firstMatch(
        in: description,
        range: NSRange(description.startIndex..., in: description)
      ),
      let nameRange = Range(match.range(at: 1), in: description)
    else {
      return nil
    }

    self.name = String(description[nameRange])
    self.isClosing = description.hasPrefix("</")
    self.isSelfClosing = description.hasSuffix("/>")

    if let hrefMatch = Constants.hrefExpression.firstMatch(
      in: description,
      range: NSRange(description.startIndex..., in: description)
    ),
       let hrefRange = Range(hrefMatch.range(at: 1), in: description) {
      self.href = String(description[hrefRange])
    } else {
      self.href = nil
    }
  }
}
