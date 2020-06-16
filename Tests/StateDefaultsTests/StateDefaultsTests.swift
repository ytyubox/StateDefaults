import XCTest
@testable import StateDefaults
import SwiftUI

struct TestTarget
{
static let key = "mytext"
    static let defaultsText = "nil"
    @StateDefaults(
//        "key",
    defaultValue: Self.defaultsText) var mytext
    
    func reset()
    {
        mytext = Self.defaultsText
    }
}

final class StateDefaultsTests: XCTestCase {
  func testStateDefaults() {
    let target = TestTarget()
    XCTAssertEqual(target.mytext, "nil")
    target.mytext = "Hello, World!"

    let get = UserDefaults.standard.string(forKey: TestTarget.key)
    XCTAssertEqual(target.mytext, get)
    target.reset()
  }
  func testProjectValue() {
    let target = TestTarget()
    target.mytext = "Hello, World!"
    let get = UserDefaults.standard.string(forKey: TestTarget.key)
    XCTAssertEqual("Hello, World!", get)
    target.reset()
  }
    func testProjectedValue() {
        let target = TestTarget()
        let expect = TestTarget.key
        target.mytext = "123"
        XCTAssertEqual(expect, target.$mytext._key)
        target.reset()
    }
  
  static var allTests = [
    ("testStateDefaults", testStateDefaults),
  ]
}
