import XCTest
@testable import StateDefaults

final class StateDefaultsTests: XCTestCase {
  @StateDefaults("key", defaultValue: "nil") var text
  func testStateDefaults() {
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
    ("testStateDefaults", testStateDefaults),
  ]
}
