import XCTest

@testable import MarkdownUI

final class DocumentTests: XCTestCase {
  func testEmptyDocument() {
    // given
    let content = ""

    // when
    let result = Document(markdown: content).blocks

    // then
    XCTAssertEqual([], result)
  }

  func testParagraph() {
    // given
    let text = "Hello world!"

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph([.text("Hello world!")]),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testSoftBreak() {
    // given
    let text = """
         Hello
             World
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello"),
              .softBreak,
              .text("World"),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testLineBreak() {
    // given
    let text = "Hello  \n      World"

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello"),
              .lineBreak,
              .text("World"),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testCodeInline() {
    // given
    let text = "Returns `nil`."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Returns "),
              .code("nil"),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testHTMLInline() {
    // given
    let text = "Returns <code>nil</code>."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Returns "),
              .html("<code>"),
              .text("nil"),
              .html("</code>"),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testEmphasis() {
    // given
    let text = "Hello _world_."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello "),
              .emphasis([.text("world")]),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testStrong() {
    // given
    let text = "Hello __world__."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello "),
              .strong([.text("world")]),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testStrikethrough() {
    // given
    let text = "Hello ~~world~~."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello "),
              .strikethrough([.text("world")]),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testLink() {
    // given
    let text = "Hello [world](https://example.com)."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello "),
              .link(
                .init(destination: "https://example.com", children: [.text("world")])
              ),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testImage() {
    // given
    let text = "Hello ![world](https://example.com/world.jpg)."

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .paragraph(
            [
              .text("Hello "),
              .image(
                .init(
                  source: "https://example.com/world.jpg", title: "", children: [.text("world")])
              ),
              .text("."),
            ]
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }
}
