import Foundation
import XCTest

@testable import MarkdownUI

final class MarkdownContentBuilderTests: XCTestCase {
  func testEmpty() {
    // given
    @MarkdownContentBuilder func build() -> MarkdownContent {}

    // when
    let result = build()

    // then
    XCTAssertEqual(.init(), result)
  }

  func testExpressions() {
    // given
    @MarkdownContentBuilder func build() -> MarkdownContent {
      "**First** paragraph."
      Paragraph {
        Strong("Second")
        " paragraph."
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      MarkdownContent(
        blocks: [
          .paragraph(
            [
              .strong([.text("First")]),
              .text(" paragraph."),
            ]
          ),
          .paragraph(
            [
              .strong([.text("Second")]),
              .text(" paragraph."),
            ]
          ),
        ]
      ),
      result
    )
  }

  func testForLoops() {
    // given
    @MarkdownContentBuilder func build() -> MarkdownContent {
      for i in 0...3 {
        "\(i)"
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      MarkdownContent(
        blocks: [
          .paragraph([.text("0")]),
          .paragraph([.text("1")]),
          .paragraph([.text("2")]),
          .paragraph([.text("3")]),
        ]
      ),
      result
    )
  }

  func testIf() {
    @MarkdownContentBuilder func build() -> MarkdownContent {
      "Something is:"
      if true {
        "true"
      }
    }

    // when
    let result = build()

    // then
    XCTAssertEqual(
      MarkdownContent(
        blocks: [
          .paragraph([.text("Something is:")]),
          .paragraph([.text("true")]),
        ]
      ),
      result
    )
  }

  func testIfElse() {
    @MarkdownContentBuilder func build(_ value: Bool) -> MarkdownContent {
      "Something is:"
      if value {
        "true"
      } else {
        "false"
      }
    }

    // when
    let result1 = build(true)
    let result2 = build(false)

    // then
    XCTAssertEqual(
      MarkdownContent(
        blocks: [
          .paragraph([.text("Something is:")]),
          .paragraph([.text("true")]),
        ]
      ),
      result1
    )
    XCTAssertEqual(
      MarkdownContent(
        blocks: [
          .paragraph([.text("Something is:")]),
          .paragraph([.text("false")]),
        ]
      ),
      result2
    )
  }
}
