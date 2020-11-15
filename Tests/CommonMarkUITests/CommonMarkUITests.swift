import XCTest
@testable import CommonMarkUI

final class CommonMarkUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CommonMarkUI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
