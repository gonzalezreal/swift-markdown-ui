#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class DocCThemeTests: XCTestCase {
    private struct TestView: View {
      var markdown: String

      init(_ markdown: String) {
        self.markdown = markdown
      }

      var body: some View {
        VStack {
          Markdown(markdown)
            .padding()
            .background(Color(.systemBackground))
            .colorScheme(.light)
          Markdown(markdown)
            .padding()
            .background(Color(.systemBackground))
            .colorScheme(.dark)
        }
        .padding()
        .markdownTheme(.docC)
      }
    }

    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testImage() {
      let view = TestView(
        #"""
        100x150 image:

        ![](asset:///237-100x150)

        ― Photo by André Spieker
        """#
      )
      .markdownImageLoader(.asset(in: .module), forURLScheme: "asset")

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testBlockQuote() {
      let view = TestView(
        #"""
        > Outside of a dog, a book is man's best friend. Inside of a
        > dog it's too dark to read.

        ― Groucho Marx
        """#
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }

#endif
