import SwiftUI

extension Theme {
  public static let basic = Theme()
    .code {
      FontFamilyVariant(.monospaced)
      FontSize(.em(0.94))
    }
    .heading1 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(2))
        }
    }
    .heading2 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.5))
        }
    }
    .heading3 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1.17))
        }
    }
    .heading4 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(1))
        }
    }
    .heading5 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(0.83))
        }
    }
    .heading6 { label in
      label
        .markdownBlockSpacing(top: .rem(1.5), bottom: .rem(1))
        .markdownTextStyle {
          FontWeight(.bold)
          FontSize(.em(0.67))
        }
    }
    .paragraph { label in
      label
        .lineSpacing(.em(0.15))
        .markdownBlockSpacing(top: .zero, bottom: .em(1))
    }
    .blockquote { label in
      label
        .markdownTextStyle {
          FontStyle(.italic)
        }
        .padding(.leading, .em(2))
        .padding(.trailing, .em(1))
    }
    .codeBlock { label in
      ScrollView(.horizontal) {
        label
          .lineSpacing(.em(0.15))
          .padding(.leading, .rem(1))
          .markdownTextStyle {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.94))
          }
      }
      .markdownBlockSpacing(top: .zero, bottom: .em(1))
    }
    .table { label in
      label.markdownBlockSpacing(top: .zero, bottom: .em(1))
    }
    .tableCell { configuration in
      configuration.label
        .markdownTextStyle {
          if configuration.row == 0 {
            FontWeight(.bold)
          }
        }
        .lineSpacing(.em(0.15))
        .padding(.horizontal, .em(0.72))
        .padding(.vertical, .em(0.35))
    }
    .thematicBreak {
      Divider().markdownBlockSpacing(top: .em(2), bottom: .em(2))
    }
}
