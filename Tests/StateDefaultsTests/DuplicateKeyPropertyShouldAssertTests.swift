import XCTest
import StateDefaults


final class DuplicateKeyPropertyShouldAssertTests: XCTestCase {
  func testduplicateTheSame() {
    let target1 = TestTaget()
    let target2 = TestTaget()
    target1.text = "newText"
    XCTAssertEqual(target1.text, target2.text)
    target1.reset()
  }
}
