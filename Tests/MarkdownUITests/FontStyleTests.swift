import Combine
import XCTest

@testable import MarkdownUI

final class FontStyleTests: XCTestCase {
  func testSystemFontStyle() {
    // given
    let fontStyle = FontStyle.system(size: 17, weight: .bold, design: .rounded)

    // when
    let font = fontStyle.resolve()

    // then
    XCTAssertEqual(.system(size: 17, design: .rounded).weight(.bold), font)
  }

  func testCustomFontStyle() {
    // given
    let fontStyle = FontStyle.custom("Menlo", size: 17)

    // when
    let font = fontStyle.resolve()

    // then
    XCTAssertEqual(.custom("Menlo", fixedSize: 17), font)
  }

  func testModifiers() {
    XCTAssertEqual(
      .system(size: 17).italic(),
      FontStyle.system(size: 17).italic().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).smallCaps(),
      FontStyle.system(size: 17).smallCaps().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).lowercaseSmallCaps(),
      FontStyle.system(size: 17).lowercaseSmallCaps().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).uppercaseSmallCaps(),
      FontStyle.system(size: 17).uppercaseSmallCaps().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).monospacedDigit(),
      FontStyle.system(size: 17).monospacedDigit().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).weight(.medium),
      FontStyle.system(size: 17).weight(.medium).resolve()
    )
    XCTAssertEqual(
      .system(size: 17).bold(),
      FontStyle.system(size: 17).bold().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).monospaced(),
      FontStyle.system(size: 17).monospaced().resolve()
    )
    XCTAssertEqual(
      .system(size: 17).leading(.loose),
      FontStyle.system(size: 17).leading(.loose).resolve()
    )
    XCTAssertEqual(
      .system(size: 17).bold().italic().monospaced(),
      FontStyle.system(size: 17).bold().italic().monospaced().resolve()
    )
  }

  func testScaleFactorAndCustomModifier() {
    // given
    let fontStyle = FontStyle.system(size: 17)
      .scaleFactor(1.5)
      .bold()
      .italic()
      .custom("Menlo", scaleFactor: 0.88)

    // when
    let font = fontStyle.resolve()

    // then
    XCTAssertEqual(.custom("Menlo", fixedSize: round(17 * 1.5 * 0.88)).bold().italic(), font)
  }
}
