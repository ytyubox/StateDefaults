import XCTest
import StateDefaults


final class DuplicateKeyPropertyShouldAssertTests: XCTestCase {
  func testduplicateKeyPropertyShouldAssert() {
    let defaults = UserDefaults(suiteName: "MultipleKeyProperty")!
    // REMINDER: - keeping the never used warming for arc
    let p1 = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
    XCTAssertPreconditionFailure(expectedMessage: "[StateDefault] key: someKey is already a property somewhere in you code. Place make sure you have only one") {
      _ = StateDefaults("someKey", defaultValue: "value", userDefaults: defaults)
    }
  }
  
  func testARCForDuplicateKey() {
    let defaults = UserDefaults(suiteName: "MultipleKeyProperty")!
    do {
      _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
    }
    
    _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
  }
}
