import XCTest
import StateDefaults


final class DuplicateKeyPropertyShouldAssertTests: XCTestCase {
  func testduplicateTheSame() {
    let target1 = TestTarget()
    let target2 = TestTarget()
    target1.mytext = "newText"
    XCTAssertEqual(target1.mytext, target2.mytext)
    target1.reset()
  }
}
