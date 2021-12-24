import XCTest

@testable import MarkdownUI

final class ColorTests: XCTestCase {
  func testStandardColors() {
    XCTAssertEqual(MarkdownStyle.Color.red.platformColor, .systemRed)
    XCTAssertEqual(MarkdownStyle.Color.orange.platformColor, .systemOrange)
    XCTAssertEqual(MarkdownStyle.Color.yellow.platformColor, .systemYellow)
    XCTAssertEqual(MarkdownStyle.Color.green.platformColor, .systemGreen)
    XCTAssertEqual(MarkdownStyle.Color.teal.platformColor, .systemTeal)
    XCTAssertEqual(MarkdownStyle.Color.blue.platformColor, .systemBlue)
    XCTAssertEqual(MarkdownStyle.Color.indigo.platformColor, .systemIndigo)
    XCTAssertEqual(MarkdownStyle.Color.purple.platformColor, .systemPurple)
    XCTAssertEqual(MarkdownStyle.Color.pink.platformColor, .systemPink)
    XCTAssertEqual(MarkdownStyle.Color.white.platformColor, .white)
    XCTAssertEqual(MarkdownStyle.Color.gray.platformColor, .systemGray)
    XCTAssertEqual(MarkdownStyle.Color.black.platformColor, .black)
    XCTAssertEqual(MarkdownStyle.Color.clear.platformColor, .clear)
    #if os(macOS)
      XCTAssertEqual(MarkdownStyle.Color.primary.platformColor, .labelColor)
      XCTAssertEqual(MarkdownStyle.Color.secondary.platformColor, .secondaryLabelColor)
    #else
      XCTAssertEqual(MarkdownStyle.Color.primary.platformColor, .label)
      XCTAssertEqual(MarkdownStyle.Color.secondary.platformColor, .secondaryLabel)
    #endif
  }

  func testColorCreation() {
    XCTAssertEqual(
      MarkdownStyle.Color(cgColor: .init(gray: 0.5, alpha: 1)).platformColor,
      .init(cgColor: .init(gray: 0.5, alpha: 1))
    )
    XCTAssertEqual(
      MarkdownStyle.Color(red: 1, green: 0, blue: 0, opacity: 0.5).platformColor,
      .init(red: 1, green: 0, blue: 0, alpha: 0.5)
    )
    XCTAssertEqual(
      MarkdownStyle.Color(white: 0.25, opacity: 0.5).platformColor,
      .init(white: 0.25, alpha: 0.5)
    )
    XCTAssertEqual(
      MarkdownStyle.Color(hue: 0.25, saturation: 0.5, brightness: 0.75, opacity: 0.5)
        .platformColor,
      .init(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 0.5)
    )
    #if os(macOS)
      XCTAssertEqual(
        MarkdownStyle.Color("test", bundle: .module).platformColor!,
        .init(named: "test", bundle: .module)!
      )
    #else
      XCTAssertEqual(
        MarkdownStyle.Color("test", bundle: .module).platformColor!,
        .init(named: "test", in: .module, compatibleWith: nil)!
      )
    #endif
  }

  func testOpacity() {
    XCTAssertEqual(
      MarkdownStyle.Color.white.opacity(0.25).platformColor,
      .white.withAlphaComponent(0.25)
    )
  }
}
