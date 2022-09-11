import SwiftUI

extension Font.TextStyle {
  internal var pointSize: CGFloat {
    PlatformFont.preferredFont(forTextStyle: .init(self)).pointSize
  }
}

#if os(macOS)
  private typealias PlatformFont = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  private typealias PlatformFont = UIFont
#endif

extension PlatformFont.TextStyle {
  fileprivate init(_ textStyle: Font.TextStyle) {
    switch textStyle {
    case .largeTitle:
      #if os(tvOS)
        self = .title1
      #else
        self = .largeTitle
      #endif
    case .title:
      self = .title1
    case .title2:
      self = .title2
    case .title3:
      self = .title3
    case .headline:
      self = .headline
    case .subheadline:
      self = .subheadline
    case .body:
      self = .body
    case .callout:
      self = .callout
    case .footnote:
      self = .footnote
    case .caption:
      self = .caption1
    case .caption2:
      self = .caption2
    @unknown default:
      self = .body
    }
  }
}
