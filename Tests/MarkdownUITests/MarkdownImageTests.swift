#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  @testable import MarkdownUI

  final class MarkdownImageTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testFailingImage() {
      let view = Markdown {
        #"""
        An image that fails to load:

        ![](https://picsum.photos/500/300)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageLoader(
        .failing.stub(
          url: URL(string: "https://picsum.photos/500/300")!,
          with: .failure(URLError(.badServerResponse))
        ),
        forURLScheme: "https"
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRelativeImage() {
      let view = Markdown(baseURL: URL(string: "https://example.com/picsum")) {
        #"""
        500x300 image:

        ![](500/300)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageLoader(
        .failing.stub(
          url: URL(string: "https://example.com/picsum/500/300")!,
          with: .success(UIImage(named: "237-500x300", in: .module, with: nil)!)
        ),
        forURLScheme: "https"
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testAssetImageLoader() {
      let view = Markdown {
        #"""
        100x150 image:

        ![](asset:///237-100x150)

        500x300 image:

        ![](asset:///237-500x300)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageLoader(.asset(in: .module), forURLScheme: "asset")

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testImageLink() {
      let view = Markdown {
        #"""
        A link that contains an image instead of text:

        [![](asset:///237-100x150)](https://example.com)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageLoader(.asset(in: .module), forURLScheme: "asset")

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testImageStyle() {
      let view = Markdown {
        #"""
        A link that contains an image instead of text:

        [![](asset:///237-100x150)](https://example.com)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageLoader(.asset(in: .module), forURLScheme: "asset")
      .markdownTheme(\.image, .alignment(.center))

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
