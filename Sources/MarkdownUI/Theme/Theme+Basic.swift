import SwiftUI

extension Theme {
  public static let basic = Theme()
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.94))
    }
    .heading1 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(2))
        }
    }
    .heading2 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.5))
        }
    }
    .heading3 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1.17))
        }
    }
    .heading4 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(1))
        }
    }
    .heading5 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.83))
        }
    }
    .heading6 { label in
      label
        .markdownBlockMargins(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.semibold)
          FontSize(.em(0.67))
        }
    }
    .paragraph { label in
      label
        .relativeLineSpacing(.em(0.15))
        .markdownBlockMargins(top: .zero, bottom: .em(1))
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
      .markdownBlockMargins(top: .zero, bottom: .em(1))
    }
    .table { label in
      label.markdownBlockMargins(top: .zero, bottom: .em(1))
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
      Divider().markdownBlockMargins(top: .em(2), bottom: .em(2))
    }
}
