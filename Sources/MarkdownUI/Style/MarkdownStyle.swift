import SwiftUI

public struct MarkdownStyle {
  var baseStyle: (inout MarkdownStyle.Attributes) -> Void
  var paragraphStyle: (inout MarkdownStyle.Attributes) -> Void
  var codeStyle: (inout MarkdownStyle.Attributes) -> Void
  var emphasisStyle: (inout MarkdownStyle.Attributes) -> Void
  var strongStyle: (inout MarkdownStyle.Attributes) -> Void
  var linkStyle: (inout MarkdownStyle.Attributes, URL?, String?) -> Void
}

extension MarkdownStyle {
  public enum Defaults {
    public static let codeFontScale: CGFloat = 0.94
  }

  static func system(
    _ textStyle: SwiftUI.Font.TextStyle = .body,
    foregroundColor: MarkdownStyle.Color = .primary,
    paragraphSpacingFactor: CGFloat = 1,
    codeFontScale: CGFloat = Defaults.codeFontScale
  ) -> MarkdownStyle {
    MarkdownStyle(
      baseStyle: { attributes in
        attributes.font = .system(textStyle)
        attributes.paragraphStyle = .default
        attributes.foregroundColor = foregroundColor
      },
      paragraphStyle: { attributes in
        attributes.paragraphStyle = attributes.paragraphStyle?
          .paragraphSpacingFactor(paragraphSpacingFactor)
      },
      codeStyle: { attributes in
        attributes.font = attributes.font?.scale(codeFontScale).monospaced()
      },
      emphasisStyle: { attributes in
        attributes.font = attributes.font?.italic()
      },
      strongStyle: { attributes in
        attributes.font = attributes.font?.bold()
      },
      linkStyle: { attributes, url, title in
        attributes.link = url
        attributes.toolTip = title
      }
    )
  }
}
