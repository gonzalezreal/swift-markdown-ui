import Combine
import CommonMark
import SwiftUI

extension Document {
  func renderAttributedString(
    environment: AttributedStringRenderer.Environment
  ) -> NSAttributedString {
    AttributedStringRenderer(environment: environment).renderDocument(self)
  }

  func renderAttributedString(
    environment: AttributedStringRenderer.Environment,
    imageHandlers: [String: MarkdownImageHandler]
  ) -> AnyPublisher<NSAttributedString, Never> {
    Deferred {
      Just(self.renderAttributedString(environment: environment))
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
