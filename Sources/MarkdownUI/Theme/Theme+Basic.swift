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
}
