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

  func testParagraphSpacingFactor() {
    XCTAssertEqual(
      MarkdownStyle.ParagraphStyle.default
        .paragraphSpacingFactor(1.5)
        .resolve(.systemFont(ofSize: 17)),
      {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(.default)
        paragraphStyle.paragraphSpacing = round(17 * 1.5)
        return paragraphStyle
      }()
    )
  }
}
