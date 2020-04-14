/// Source:
/// https://gist.github.com/nschum/208b3dde43785afd439a
/// https://stackoverflow.com/questions/36693074/testing-swift-code-with-preconditions
///


import XCTest
import StateDefaults

extension XCTestCase {
    func XCTAssertPreconditionFailure(expectedMessage: String,  block:  () -> ()) {

			let _expectation = expectation(description: "failing precondition")

        // Overwrite `precondition` with something that doesn't terminate but verifies it happened.
        preconditionClosure = {
            (condition, message, file, line) in
            if !condition {
                _expectation.fulfill()
                XCTAssertEqual(message, expectedMessage, "precondition message didn't match", file: file, line: line)
            }
        }

        // Call code.
        block();

        // Verify precondition "failed".
			waitForExpectations(timeout: 1.0, handler: nil)

        // Reset precondition.
        preconditionClosure = defaultPreconditionClosure
    }
}
