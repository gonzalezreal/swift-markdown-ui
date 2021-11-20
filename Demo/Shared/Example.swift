import Foundation
import MarkdownUI

struct Example: Identifiable, Hashable {
  var id: String
  var title: String
  var document: String
  var useDefaultStyle = true

  var style: MarkdownStyle {
    useDefaultStyle
      ? DefaultMarkdownStyle(font: .system(.body))
      : DefaultMarkdownStyle(
        font: .system(.body, design: .serif),
        codeFontName: "Menlo",
        codeFontSizeMultiple: 0.88
      )
  }
}

extension Example {
  static let text = Example(
    id: "text",
    title: "Text",
    document: #"""
      These examples are blatantly copied from [Mastering
      Markdown](https://guides.github.com/features/mastering-markdown/).

      It's very easy to make some words **bold** and other words *italic* with Markdown.

      **Want to experiment with Markdown?** Play with the [reference CommonMark
      implementation](https://spec.commonmark.org/dingus/).
      """#
  )

  static let lists = Example(
    id: "lists",
    title: "Lists",
    document: #"""
      Sometimes you want numbered lists:

      1. One
      1. Two
      1. Three

      Sometimes you want bullet points:

      * Start a line with a star
      * Profit!

      Alternatively,

      - Dashes work just as well
      - And if you have sub points, put two spaces before the dash or star:
        - Like this
        - And this
      """#
  )

  static let images = Example(
    id: "images",
    title: "Images",
    document: #"""
      If you want to embed images, this is how you do it:

      ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")
      """#
  )

  static let headers = Example(
    id: "headers",
    title: "Headers & Quotes",
    document: #"""
      # Structured documents

      Sometimes it's useful to have different levels of headings to structure your documents. Start lines with a `#` to create headings. Multiple `##` in a row denote smaller heading sizes.

      ### This is a third-tier heading

      You can use one `#` all the way up to `######` six for different heading sizes.

      If you'd like to quote someone, use the > character before the line:

      > Coffee. The finest organic suspension ever devised... I beat the Borg with it.
      > \- Captain Janeway
      """#
  )

  static let code = Example(
    id: "code",
    title: "Code",
    document: #"""
      There are many different ways to style code with CommonMark. If you have inline code blocks, wrap them in backticks: `var example = true`.  If you've got a longer block of code, you can indent with four spaces:

          if isAwesome {
            return true
          }

      CommonMark also supports something called code fencing, which allows for multiple lines without indentation:

      ```
      if isAwesome {
        return true
      }
      ```
      """#
  )

  static let style = Example(
    id: "style",
    title: "Style",
    document: #"""
      ## Markdown Style
      By default, MardownUI renders markdown strings using the system fonts and reasonable defaults for paragraph spacing, indent size, heading size, etc.

      If you don't want to use the default style, you can provide a custom `MarkdownStyle` by using the `markdownStyle()` modifier:

      ```
      .markdownStyle(
        DefaultMarkdownStyle(
            font: .system(
              .body,
              design: .serif
            ),
            codeFontName: "Menlo"
        )
      )
      ```
      """#,
    useDefaultStyle: false
  )

  static let all: [Example] = [
    .text,
    .lists,
    .images,
    .headers,
    .code,
    .style,
  ]
}
