//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/4/13.
//

import XCTest
@testable import StateDefaults

final class StateDefaultsShareTests: XCTestCase {
    func testChangeDefaults() {
        let defaults = UserDefaults(suiteName: "TestingStateDefaults")
        XCTAssertNotNil(defaults)
        
        let stateDefaultValue = StateDefaults<Int>(
//            "text",
            defaultValue: 1,
            userDefaults: defaults)
        let r = Int.random(in: 0...Int.max)
        stateDefaultValue.wrappedValue = r
        
        let expect = defaults?.integer(forKey: stateDefaultValue.projectedValue._key!)
        
        XCTAssertEqual(expect, r)
    }
}
