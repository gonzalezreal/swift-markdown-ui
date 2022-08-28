#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
    private let backgroundColor = Color(uiColor: .secondarySystemBackground)

    func testParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testCenteredParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.center)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testTrailingParagraphs() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .multilineTextAlignment(.trailing)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testSpacing() {
      let view = Markdown(
        #"""
        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.

        The sky above the port was the color of television, tuned to a dead channel.

        It was a bright cold day in April, and the clocks were striking thirteen.
        """#
      )
      .markdownSpacing(0)
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlines() {
      let view = Markdown(
        #"""
        **This is bold text**

        *This text is italicized*

        ~~This was mistaken text~~

        **This text is _extremely_ important**

        ***All this text is important***

        MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).

        Visit https://github.com.

        Use `git status` to list all new or modified files that haven't yet been committed.
        """#
      )
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testInlinesStyling() {
      let view = Markdown(
        #"""
        **This is bold text**

        *This text is italicized*

        ~~This was mistaken text~~

        **This text is _extremely_ important**

        ***All this text is important***

        MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).

        Visit https://github.com.

        Use `git status` to list all new or modified files that haven't yet been committed.
        """#
      )
      .markdownInlineCodeStyle { configuration in
        Text(
          AttributedString(
            configuration.content,
            attributes: AttributeContainer()
              .backgroundColor(Color.yellow)
              .font((configuration.font ?? .body).monospaced())
          )
        )
      }
      .markdownEmphasisStyle { configuration in
        configuration.label.italic().foregroundColor(.brown)
      }
      .markdownLinkStyle { configuration in
        Text(
          AttributedString(
            configuration.content,
            attributes: AttributeContainer()
              .link(configuration.url)
              .underlineStyle(.init(pattern: .dot))
          )
        )
      }
      .background(backgroundColor)
      .padding()

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
