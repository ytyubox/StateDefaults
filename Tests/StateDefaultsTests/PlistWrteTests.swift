//
//  File.swift
//  
//
//  Created by 游宗諭 on 2020/6/7.
//

import XCTest
import StateDefaults

class PlistWrteTests:XCTestCase {
    func testGetURL() {
        
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let preferences = try? FileManager()
                .url(for: .libraryDirectory,
                     in: .userDomainMask,
                     appropriateFor: .none,
                     create: false)
                .appendingPathComponent("Preferences/\(bundleID).plist")
            else
        {
            fatalError("Could not find the preferences folder.")
            
        }
        print(preferences)
        
        let data = try! Data(contentsOf: preferences)
        let plist = try! PropertyListSerialization
            .propertyList(
                from: data,
                options: .mutableContainers,
                format: .none)
        print(plist)
    }
}
