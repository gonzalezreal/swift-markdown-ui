#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

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

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testRelativeImage() {
      let view = Markdown(baseURL: URL(string: "https://example.com/picsum")) {
        #"""
        500x300 image:

        ![](237-500x300)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageProvider(
        AssetImageProvider(
          name: { url in
            XCTAssertEqual(URL(string: "https://example.com/picsum/237-500x300")!, url)
            return url.lastPathComponent
          },
          bundle: .module
        )
      )

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testImageLink() {
      let view = Markdown {
        #"""
        A link that contains an image instead of text:

        [![](https://example.com/picsum/237-100x150)](https://example.com)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageProvider(AssetImageProvider(bundle: .module))

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testMultipleImages() throws {
      guard #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) else {
        throw XCTSkip("Required API is not available for this test")
      }

      let view = Markdown {
        #"""
        [![](https://example.com/picsum/237-100x150)](https://example.com)
        ![](https://example.com/picsum/237-125x75)
        ![](https://example.com/picsum/237-500x300)
        ![](https://example.com/picsum/237-100x150)\#u{20}\#u{20}
        ![](https://example.com/picsum/237-125x75)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageProvider(AssetImageProvider(bundle: .module))

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testMultipleImagesSize() throws {
      guard #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) else {
        throw XCTSkip("Required API is not available for this test")
      }

      let view = Markdown {
        #"""
        ![](https://example.com/picsum/237-100x150)
        ![](https://example.com/picsum/237-125x75)

        ― Photo by André Spieker
        """#
      }
      .border(Color.accentColor)
      .padding()
      .markdownImageProvider(AssetImageProvider(bundle: .module))

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }
#endif
