import SwiftUI

extension Theme {
  /// The default Markdown theme.
  ///
  /// Style | Preview
  /// --- | ---
  /// Inline text | ![](BasicInlines)
  /// Headings | ![](Heading)
  /// Blockquote | ![](BlockquoteContent)
  /// Code block | ![](CodeBlock)
  /// Image | ![](Paragraph)
  /// Task list | ![](TaskList)
  /// Bulleted list | ![](NestedBulletedList)
  /// Numbered list | ![](NumberedList)
  /// Table | ![](Table-Collection)
  public static let basic = Theme()
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.94))
    }
    .heading1 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(2))
        }
    }
    .heading2 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.5))
        }
    }
    .heading3 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.17))
        }
    }
    .heading4 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1))
        }
    }
    .heading5 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.83))
        }
    }
    .heading6 { label in
      label
        .markdownMargin(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.67))
        }
    }
    .paragraph { label in
      label
        .relativeLineSpacing(.em(0.15))
        .markdownMargin(top: .zero, bottom: .em(1))
    }
    .blockquote { label in
      label
        .markdownTextStyle {
          FontStyle(.italic)
        }
        .relativePadding(.leading, length: .em(2))
        .relativePadding(.trailing, length: .em(1))
    }
    .codeBlock { label in
      ScrollView(.horizontal) {
        label
          .relativeLineSpacing(.em(0.15))
          .relativePadding(.leading, length: .rem(1))
          .markdownTextStyle {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.94))
          }
      }
      .markdownMargin(top: .zero, bottom: .em(1))
    }
    .table { label in
      label.markdownMargin(top: .zero, bottom: .em(1))
    }
    .tableCell { configuration in
      configuration.label
        .markdownTextStyle {
          if configuration.row == 0 {
            FontWeight(.semibold)
          }
        }
        .relativeLineSpacing(.em(0.15))
        .relativePadding(.horizontal, length: .em(0.72))
        .relativePadding(.vertical, length: .em(0.35))
    }
    .thematicBreak {
      Divider().markdownMargin(top: .em(2), bottom: .em(2))
    }
}
