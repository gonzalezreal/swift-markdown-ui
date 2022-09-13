import XCTest

@testable import MarkdownUI

final class DocumentTests: XCTestCase {
  func testEquatable() {
    // given
    let a = Document(markdown: "Hello")
    let b = Document(markdown: "Lorem *ipsum*")
    let c = a
    let d = Document(markdown: "Lorem _ipsum_")

    // then
    XCTAssertNotEqual(a, b)
    XCTAssertEqual(a, c)
    XCTAssertEqual(b, d)
  }

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

  func testList() {
    // given
    let text = """
         1. one
         1. two
            - nested 1
            - nested 2
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .list(
            List(
              children: [
                Block(
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          content: .paragraph([.text("one")]),
                          hasSuccessor: false
                        )
                      ]
                    )
                  ),
                  hasSuccessor: true
                ),
                Block(
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          content: .paragraph([.text("two")]),
                          hasSuccessor: true
                        ),
                        Block(
                          content: .list(
                            List(
                              children: [
                                Block(
                                  content: .listItem(
                                    ListItem(
                                      children: [
                                        Block(
                                          content: .paragraph([.text("nested 1")]),
                                          hasSuccessor: false
                                        )
                                      ]
                                    )
                                  ),
                                  hasSuccessor: true
                                ),
                                Block(
                                  content: .listItem(
                                    ListItem(
                                      children: [
                                        Block(
                                          content: .paragraph([.text("nested 2")]),
                                          hasSuccessor: false
                                        )
                                      ]
                                    )
                                  ),
                                  hasSuccessor: false
                                ),
                              ],
                              isTight: true,
                              listType: .unordered
                            )
                          ),
                          hasSuccessor: false
                        ),
                      ]
                    )
                  ),
                  hasSuccessor: false
                ),
              ],
              isTight: true,
              listType: .ordered(start: 1)
            )
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testLooseList() {
    // given
    let text = """
         9. one

         1. two
            - [ ] nested 1
            - [x] nested 2
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        Block(
          content: .list(
            List(
              children: [
                Block(
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          content: .paragraph([.text("one")]),
                          hasSuccessor: false
                        )
                      ]
                    )
                  ),
                  hasSuccessor: true
                ),
                Block(
                  content: .listItem(
                    ListItem(
                      children: [
                        Block(
                          content: .paragraph([.text("two")]),
                          hasSuccessor: true
                        ),
                        Block(
                          content: .list(
                            List(
                              children: [
                                Block(
                                  content: .listItem(
                                    ListItem(
                                      checkbox: .unchecked,
                                      children: [
                                        Block(
                                          content: .paragraph([.text("nested 1")]),
                                          hasSuccessor: false
                                        )
                                      ]
                                    )
                                  ),
                                  hasSuccessor: true
                                ),
                                Block(
                                  content: .listItem(
                                    ListItem(
                                      checkbox: .checked,
                                      children: [
                                        Block(
                                          content: .paragraph([.text("nested 2")]),
                                          hasSuccessor: false
                                        )
                                      ]
                                    )
                                  ),
                                  hasSuccessor: false
                                ),
                              ],
                              isTight: true,
                              listType: .unordered
                            )
                          ),
                          hasSuccessor: false
                        ),
                      ]
                    )
                  ),
                  hasSuccessor: false
                ),
              ],
              isTight: false,
              listType: .ordered(start: 9)
            )
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }

  func testBlockQuote() {
    // given
    let text = """
        >Hello
        >>World
      """

    // when
    let result = Document(markdown: text).blocks

    // then
    XCTAssertEqual(
      [
        .init(
          content: .blockquote(
            .init(
              children: [
                .init(content: .paragraph([.text("Hello")]), hasSuccessor: true),
                .init(
                  content: .blockquote(
                    .init(
                      children: [
                        .init(content: .paragraph([.text("World")]), hasSuccessor: false)
                      ]
                    )
                  ),
                  hasSuccessor: false
                ),
              ]
            )
          ),
          hasSuccessor: false
        )
      ],
      result
    )
  }
}
