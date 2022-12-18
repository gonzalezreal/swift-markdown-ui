import MarkdownUI
import SwiftUI

struct TextStylesView: View {
  private let content = """
    ```
    **This is bold text**
    ```
    **This is bold text**
    ```
    *This text is italicized*
    ```
    *This text is italicized*
    ```
    ~~This was mistaken text~~
    ```
    ~~This was mistaken text~~
    ```
    **This text is _extremely_ important**
    ```
    **This text is _extremely_ important**
    ```
    ***All this text is important***
    ```
    ***All this text is important***
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    Visit https://github.com.
    ```
    Visit https://github.com.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    """

  var body: some View {
    DemoView {
      Markdown(self.content)

      Section("Customization Example") {
        Markdown(self.content)
      }
      .markdownTheme(\.code, .monospaced(backgroundColor: .yellow.opacity(0.5)))
      .markdownTheme(
        \.emphasis,
        InlineStyle { attributes in
          attributes.fontStyle = attributes.fontStyle?.italic()
          attributes.underlineStyle = .single
        }
      )
      .markdownTheme(\.strong, .weight(.heavy))
      .markdownTheme(
        \.strikethrough,
        InlineStyle { attributes in
          attributes.foregroundColor = .primary
          attributes.backgroundColor = .primary
        }
      )
      .markdownTheme(
        \.link,
        InlineStyle { attributes in
          attributes.foregroundColor = .mint
          attributes.underlineStyle = .init(pattern: .dot)
        }
      )
    }
    .navigationTitle("Text Styles")
  }
}

struct TextStylesView_Previews: PreviewProvider {
  static var previews: some View {
    TextStylesView()
  }
}
