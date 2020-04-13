//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/4/13.
//

import XCTest
import StateDefaults

final class StateDefaultsShareTests: XCTestCase {
  func testChangeDefaults() {
    let defaults = UserDefaults(suiteName: "TestingSateDefaults")
    XCTAssertNotNil(defaults)
    AnyStateDefaults.defaults = defaults!
    
    let stateDefaultValue = StateDefaults<Int>("text", defaultValue: 1)
    let r = Int.random(in: 0...Int.max)
    stateDefaultValue.wrappedValue = r
    
    sleep(1)
    
    let expect = defaults?.integer(forKey: "text")
    
    XCTAssertEqual(expect, r)
    
    AnyStateDefaults.defaults = .standard
  }
}
