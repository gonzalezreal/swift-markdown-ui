import MarkdownUI
import XCTest

final class MarkdownContentTests: XCTestCase {
  func testEmpty() {
    // when
    let content = MarkdownContent("")

    // then
    XCTAssertEqual(MarkdownContent {}, content)
  }

  func testBlockquote() {
    // when
    let content = MarkdownContent {
      """
        >Hello
        >>World
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        Blockquote {
          "Hello"
          Blockquote {
            "World"
          }
        }
      },
      content
    )
  }

  func testList() {
    // when
    let content = MarkdownContent {
      """
         1. one
         1. two
            - nested 1
            - nested 2
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        NumberedList {
          "one"
          ListItem {
            "two"
            BulletedList {
              "nested 1"
              "nested 2"
            }
          }
        }
      },
      content
    )
  }

  func testLooseList() {
    // when
    let content = MarkdownContent {
      """
         9. one

         1. two
            - nested 1
            - nested 2
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        NumberedList(tight: false, start: 9) {
          "one"
          ListItem {
            "two"
            BulletedList {
              "nested 1"
              "nested 2"
            }
          }
        }
      },
      content
    )
  }

  func testTaskList() {
    // when
    let content = MarkdownContent {
      """
         - [ ] one
         - [x] two
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        TaskList {
          "one"
          TaskListItem(isCompleted: true) {
            "two"
          }
        }
      },
      content
    )
  }

  func testCodeBlock() {
    // when
    let content = MarkdownContent {
      """
      ```swift
      let a = 5
      let b = 42
      ```
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        CodeBlock(language: "swift") {
          """
          let a = 5
          let b = 42

          """
        }
      },
      content
    )
  }

  func testParagraph() {
    // when
    let content = MarkdownContent("Hello world!")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello world!"
        }
      },
      content
    )
  }

  func testHeading() {
    // when
    let content = MarkdownContent {
      """
         # Hello
         ## World
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        Heading {
          "Hello"
        }
        Heading(.level2) {
          "World"
        }
      },
      content
    )
  }

  func testTable() throws {
    guard #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) else {
      throw XCTSkip("Required API is not available for this test")
    }

    // when
    let content = MarkdownContent {
      """
      | Default    | Leading    | Center     | Trailing   |
      | ---        | :---       |    :---:   |       ---: |
      | git status | git status | git status | git status |
      | git diff   | git diff   | git diff   | git diff   |
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        TextTable {
          TextTableColumn(title: "Default", value: \.[0])
          TextTableColumn(alignment: .leading, title: "Leading", value: \.[1])
          TextTableColumn(alignment: .center, title: "Center", value: \.[2])
          TextTableColumn(alignment: .trailing, title: "Trailing", value: \.[3])
        } rows: {
          TextTableRow(Array(repeating: "git status", count: 4))
          TextTableRow(Array(repeating: "git diff", count: 4))
        }
      },
      content
    )
  }

  func testThematicBreak() {
    // when
    let content = MarkdownContent {
      """
      Foo
      ***
      Bar
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        "Foo"
        ThematicBreak()
        "Bar"
      },
      content
    )
  }

  func testSoftBreak() {
    // when
    let content = MarkdownContent {
      """
         Hello
             World
      """
    }

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello"
          SoftBreak()
          "World"
        }
      },
      content
    )
  }

  func testLineBreak() {
    // when
    let content = MarkdownContent("Hello  \n      World")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello"
          LineBreak()
          "World"
        }
      },
      content
    )
  }

  func testCode() {
    // when
    let content = MarkdownContent("Returns `nil`.")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Returns "
          Code("nil")
          "."
        }
      },
      content
    )
  }

  func testEmphasis() {
    // when
    let content = MarkdownContent("Hello _world_.")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello "
          Emphasis("world")
          "."
        }
      },
      content
    )
  }

  func testStrong() {
    // when
    let content = MarkdownContent("Hello __world__.")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello "
          Strong("world")
          "."
        }
      },
      content
    )
  }

  func testStrikethrough() {
    // when
    let content = MarkdownContent("Hello ~world~.")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello "
          Strikethrough("world")
          "."
        }
      },
      content
    )
  }

  func testLink() {
    // when
    let content = MarkdownContent("Hello [world](https://example.com).")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          "Hello "
          InlineLink("world", destination: URL(string: "https://example.com")!)
          "."
        }
      },
      content
    )
  }

  func testImage() {
    // when
    let content = MarkdownContent("![Puppy](https://picsum.photos/id/237/200/300)")

    // then
    XCTAssertEqual(
      MarkdownContent {
        Paragraph {
          InlineImage("Puppy", source: URL(string: "https://picsum.photos/id/237/200/300")!)
        }
      },
      content
    )
  }
}
