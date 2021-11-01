import SwiftUI

public struct MarkdownStyle {
  var baseStyle: (inout MarkdownStyle.Attributes) -> Void
  var blockQuoteStyle: (inout MarkdownStyle.Attributes) -> Void
  var paragraphStyle: (inout MarkdownStyle.Attributes) -> Void
  var codeStyle: (inout MarkdownStyle.Attributes) -> Void
  var emphasisStyle: (inout MarkdownStyle.Attributes) -> Void
  var strongStyle: (inout MarkdownStyle.Attributes) -> Void
  var linkStyle: (inout MarkdownStyle.Attributes, URL?, String?) -> Void
}

extension MarkdownStyle {
  public static func `default`(
    font: MarkdownStyle.Font = .body,
    foregroundColor: Color = .primary,
    measurements: Measurements = .default
  ) -> MarkdownStyle {
    MarkdownStyle(
      baseStyle: { attributes in
        attributes.font = font
        attributes.paragraphStyle = .default
        attributes.foregroundColor = foregroundColor
      },
      blockQuoteStyle: { attributes in
        attributes.font = attributes.font?.italic()
        attributes.paragraphStyle = attributes.paragraphStyle?
          .addHeadIndent(measurements.headIndentStep)
          .addTailIndent(measurements.tailIndentStep)
      },
      paragraphStyle: { attributes in
        attributes.paragraphStyle = attributes.paragraphStyle?
          .paragraphSpacing(measurements.paragraphSpacing)
      },
      codeStyle: { attributes in
        attributes.font = attributes.font?.scale(measurements.codeFontScale).monospaced()
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
