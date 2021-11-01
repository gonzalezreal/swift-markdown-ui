import XCTest

@testable import MarkdownUI

final class ParagraphStyleTests: XCTestCase {
  func testCreation() {
    XCTAssertEqual(MarkdownStyle.ParagraphStyle.default.resolve(nil), .default)
  }

  func testLayoutDirectionAndTextAlignment() {
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .layoutDirection(.rightToLeft)
        .resolve(nil),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.baseWritingDirection = .rightToLeft
        return paragraphStyle
      }()
    )
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .layoutDirection(.rightToLeft)
        .textAlignment(.trailing)
        .resolve(nil),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.baseWritingDirection = .rightToLeft
        paragraphStyle.alignment = .left
        return paragraphStyle
      }()
    )
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .layoutDirection(.leftToRight)
        .textAlignment(.trailing)
        .resolve(nil),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.baseWritingDirection = .leftToRight
        paragraphStyle.alignment = .right
        return paragraphStyle
      }()
    )
  }

  func testParagraphSpacing() {
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .paragraphSpacing(1.5)
        .resolve(.systemFont(ofSize: 17)),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.paragraphSpacing = round(17 * 1.5)
        return paragraphStyle
      }()
    )
  }

  func testAddHeadIndent() {
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .addHeadIndent(0.5)
        .addHeadIndent(0.5)
        .resolve(.systemFont(ofSize: 17)),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.headIndent = round(17 * 0.5) + round(17 * 0.5)
        paragraphStyle.firstLineHeadIndent = paragraphStyle.headIndent
        return paragraphStyle
      }()
    )
  }

  func testAddTailIndent() {
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .addTailIndent(-0.5)
        .addTailIndent(-0.5)
        .resolve(.systemFont(ofSize: 17)),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.tailIndent = round(17 * -0.5) + round(17 * -0.5)
        return paragraphStyle
      }()
    )
  }
}
