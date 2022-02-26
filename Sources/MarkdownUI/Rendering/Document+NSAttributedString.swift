import Combine
import CommonMark
import SwiftUI

extension Document {
  func renderAttributedString(
    baseURL: URL?,
    baseWritingDirection: NSWritingDirection,
    alignment: NSTextAlignment,
    lineSpacing: CGFloat,
    sizeCategory: ContentSizeCategory,
    style: MarkdownStyle
  ) -> NSAttributedString {
    AttributedStringRenderer(
      baseURL: baseURL,
      baseWritingDirection: baseWritingDirection,
      alignment: alignment,
      lineSpacing: lineSpacing,
      sizeCategory: sizeCategory,
      style: style
    ).renderDocument(self)
  }

  func renderAttributedString(
    baseURL: URL?,
    baseWritingDirection: NSWritingDirection,
    alignment: NSTextAlignment,
    lineSpacing: CGFloat,
    sizeCategory: ContentSizeCategory,
    style: MarkdownStyle,
    imageHandlers: [String: MarkdownImageHandler]
  ) -> AnyPublisher<NSAttributedString, Never> {
    Deferred {
      Just(
        self.renderAttributedString(
          baseURL: baseURL,
          baseWritingDirection: baseWritingDirection,
          alignment: alignment,
          lineSpacing: lineSpacing,
          sizeCategory: sizeCategory,
          style: style
        )
      )
    }
    .flatMap { attributedString -> AnyPublisher<NSAttributedString, Never> in
      guard attributedString.hasMarkdownImages else {
        return Just(attributedString).eraseToAnyPublisher()
      }
      return NSAttributedString.loadingMarkdownImages(
        from: attributedString,
        using: imageHandlers
      )
      .prepend(attributedString)
      .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
}
