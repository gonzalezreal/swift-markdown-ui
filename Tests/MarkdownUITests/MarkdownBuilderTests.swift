#if os(iOS)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import MarkdownUI

  final class MarkdownBuilderTests: XCTestCase {
    private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)

    func testInlineContentBuilder() {
      let view = Markdown {
        Paragraph {}
        Paragraph {
          "Hello world!"
        }
        Paragraph {
          "Hello "
          Strong {
            "world"
          }
          "!"
        }
        Paragraph {
          for i in 1..<5 {
            if i == 1 {
              "World "
            } else {
              "word "
            }
            Emphasis {
              "\(i)"
            }
            if i < 4 {
              ", "
            }
          }
          "."
        }
      }

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testBlockContentBuilder() {
      let view = Markdown {
        Paragraph {
          "First paragraph!"
        }
        for i in 2..<5 {
          "Paragraph _\(i)_."
        }
        "Last paragraph."
      }

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testBlockContentBuilderWithImages() {
      let view = Markdown {
        "This is a regular image:"
        Image(url: URL(string: "asset:///237-500x300"))
        "This is an image link:"
        Link(
          url: URL(string: "https://example.com"),
          image: Image(url: URL(string: "asset:///237-100x150"))
        )
      }
      .markdownImageLoader(.asset(in: .module), forURLScheme: "asset")

      assertSnapshot(matching: view, as: .image(layout: layout))
    }

    func testListContentBuilder() {
      let data = [
        (name: "Hats", isDone: true),
        (name: "Caps", isDone: false),
        (name: "Bonnets", isDone: false),
      ]

      let view = Markdown {
        NumberedList(data: data) { item in
          ListItem {
            "**Headgear**: \(item.name)"
          }
        }
        BulletedList(data: data) { item in
          ListItem {
            "**Headgear**: \(item.name)"
          }
        }
        TaskList(data: data) { item in
          ListItem(checkbox: item.isDone ? .checked : .unchecked) {
            "**Headgear**: \(item.name)"
          }
        }
        NumberedList {
          ListItem {
            "This is the first item."
          }
          for item in data {
            ListItem {
              "**Headgear**: \(item.name)"
            }
          }
          ListItem {
            "This is the last item."
          }
        }
      }

      assertSnapshot(matching: view, as: .image(layout: layout))
    }
  }

#endif
