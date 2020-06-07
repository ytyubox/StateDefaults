import XCTest
@testable import StateDefaults
import SwiftUI

struct TestTaget {
  @StateDefaults("key", defaultValue: "nil") var text
}

final class StateDefaultsTests: XCTestCase {
  func testStateDefaults() {
    let target = TestTaget()
    XCTAssertEqual(target.text, "nil")
    target.text = "Hello, World!"
    while !UserDefaults.standard.synchronize() {
      print("saving")
    }
    let get = UserDefaults.standard.string(forKey: "key")
    XCTAssertEqual("Hello, World!", get)
    target.text = "nil"
  }
  func testProjectValue() {
    let target = TestTaget()
    target.text = "Hello, World!"
    let get = UserDefaults.standard.string(forKey: "key")
    XCTAssertEqual("Hello, World!", get)
     UserDefaults.standard.removeObject(forKey: "key")
  }
  
  static var allTests = [
    ("testStateDefaults", testStateDefaults),
  ]
}
