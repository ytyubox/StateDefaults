import XCTest
@testable import StateDefaults

final class StateDefaultsTests: XCTestCase {
	@StateDefaults("key", defaultValue: "nil") var text
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(text, "nil")
			text = "Hello, World!"
			while !UserDefaults.standard.synchronize() {
				print("saving")
			}
			let get = UserDefaults.standard.string(forKey: "key")
			XCTAssertEqual("Hello, World!", get)
			text = "nil"
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
