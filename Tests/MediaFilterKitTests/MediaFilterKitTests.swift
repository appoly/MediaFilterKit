import XCTest
@testable import MediaFilterKit

final class MediaFilterKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MediaFilterKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
