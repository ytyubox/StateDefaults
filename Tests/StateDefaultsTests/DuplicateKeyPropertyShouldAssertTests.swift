import XCTest
import StateDefaults


final class DuplicateKeyPropertyShouldAssertTests: XCTestCase {
  func testduplicateTheSame() {
    let defaults = UserDefaults(suiteName: "MultipleKeyProperty")!
    // REMINDER: - keeping the never used warming for arc
    let p1 = StateDefaults("someKey", defaultValue: 1)
    let p2 = StateDefaults("someKey", defaultValue: "value")
//    p1.defaultsWrapper.id = "2"
//    XCTAssertFalse(p1.defaultsWrapper === p2.defaultsWrapper)
  }
}

func testARCForDuplicateKey() {
  let defaults = UserDefaults(suiteName: "MultipleKeyProperty")!
  do {
    _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
  }
  
  _ = StateDefaults("someKey", defaultValue: 1, userDefaults: defaults)
}

