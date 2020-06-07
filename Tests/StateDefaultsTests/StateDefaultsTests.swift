import XCTest
@testable import StateDefaults
import SwiftUI

struct TestTaget
{
    static let defaultsText = "nil"
    @StateDefaults("key", defaultValue: Self.defaultsText) var text
    
    func reset()
    {
        text = Self.defaultsText
    }
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
    target.reset()
  }
  func testProjectValue() {
    let target = TestTaget()
    target.text = "Hello, World!"
    let get = UserDefaults.standard.string(forKey: "key")
    XCTAssertEqual("Hello, World!", get)
    target.reset()
  }
  
  static var allTests = [
    ("testStateDefaults", testStateDefaults),
  ]
}
