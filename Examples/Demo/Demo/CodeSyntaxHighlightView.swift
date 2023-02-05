import MarkdownUI
import Splash
import SwiftUI

struct CodeSyntaxHighlightView: View {
  @Environment(\.colorScheme) private var colorScheme

  private let content = #"""
    This screen demonstrates how you can integrate a 3rd party library
    to render syntax-highlighted code blocks.

    First, we create a type that conforms to `CodeSyntaxHighlighter`,
    using [John Sundell's Splash](https://github.com/JohnSundell/Splash)
    to highlight code blocks.

    ```swift
    import MarkdownUI
    import Splash
    import SwiftUI

    struct SplashCodeSyntaxHighlighter: CodeSyntaxHighlighter {
      private let syntaxHighlighter: SyntaxHighlighter<TextOutputFormat>

      init(theme: Splash.Theme) {
        self.syntaxHighlighter = SyntaxHighlighter(format: TextOutputFormat(theme: theme))
      }

      func highlightCode(_ content: String, language: String?) -> Text {
        guard language?.lowercased() == "swift" else {
          return Text(content)
        }

        return self.syntaxHighlighter.highlight(content)
      }
    }

    extension CodeSyntaxHighlighter where Self == SplashCodeSyntaxHighlighter {
      static func splash(theme: Splash.Theme) -> Self {
        SplashCodeSyntaxHighlighter(theme: theme)
      }
    }
    ```

    Then we configure the `Markdown` view to use the `SplashCodeSyntaxHighlighter`
    that we just created.

    ```swift
    var body: some View {
      Markdown(self.content)
        .markdownCodeSyntaxHighlighter(.splash(theme: .sunset(withFont: .init(size: 16))))
    }
    ```
    """#

  var body: some View {
    DemoView {
      Markdown(self.content)
        .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
    }
  }

  private var theme: Splash.Theme {
    // NOTE: We are ignoring the Splash theme font
    switch self.colorScheme {
    case .dark:
      return .wwdc17(withFont: .init(size: 16))
    default:
      return .sunset(withFont: .init(size: 16))
    }
  }
}

struct CodeSyntaxHighlightView_Previews: PreviewProvider {
  static var previews: some View {
    CodeSyntaxHighlightView()
  }
}
