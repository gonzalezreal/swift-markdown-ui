import Splash
import SwiftUI

struct TextOutputFormat: OutputFormat {
  private let theme: Theme

  init(theme: Theme) {
    self.theme = theme
  }

  func makeBuilder() -> Builder {
    Builder(theme: self.theme)
  }
}

extension TextOutputFormat {
  struct Builder: OutputBuilder {
    private let theme: Theme
    private var accumulatedText: [AttributedString]

    fileprivate init(theme: Theme) {
      self.theme = theme
      self.accumulatedText = []
    }

    mutating func addToken(_ token: String, ofType type: TokenType) {
      let color = self.theme.tokenColors[type] ?? self.theme.plainTextColor
      var aster = AttributedString(token)
      aster.foregroundColor = .init(uiColor: color)
      self.accumulatedText.append(aster)
    }

    mutating func addPlainText(_ text: String) {
      var aster = AttributedString(text)
      aster.foregroundColor = .init(uiColor: self.theme.plainTextColor)
      self.accumulatedText.append(aster)
    }

    mutating func addWhitespace(_ whitespace: String) {
      self.accumulatedText.append(AttributedString(whitespace))
    }

    func build() -> Text {
      let text = self.accumulatedText.reduce(AttributedString(""), +)
      return Text(text)
    }
  }
}
