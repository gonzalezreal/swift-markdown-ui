import SwiftUI

extension MarkdownStyle {
  public struct Attributes {
    public var font: MarkdownStyle.Font?
    public var paragraphStyle: MarkdownStyle.ParagraphStyle?
    public var foregroundColor: MarkdownStyle.Color?
    public var link: URL?
    public var toolTip: String?
  }
}

extension MarkdownStyle.Attributes {
  func resolve() -> [NSAttributedString.Key: Any] {
    var attributes: [NSAttributedString.Key: Any] = [:]
    var platformFont: MarkdownStyle.PlatformFont?

    if let font = font {
      platformFont = font.resolve()
      attributes[.font] = platformFont
    }

    if let paragraphStyle = paragraphStyle {
      attributes[.paragraphStyle] = paragraphStyle.resolve(platformFont)
    }

    if let foregroundColor = foregroundColor {
      attributes[.foregroundColor] = foregroundColor.resolve()
    }

    if let link = link {
      attributes[.link] = link
    }

    #if os(macOS)
      if let toolTip = toolTip {
        attributes[.toolTip] = toolTip
      }
    #endif

    return attributes
  }
}
