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
        
        let preferences = getURL()
        
        let data = try! Data(contentsOf: preferences)
        let plist = try! PropertyListSerialization
            .propertyList(
                from: data,
                options: .mutableContainers,
                format: .none)
        print(plist)
    }
    func testWritePlist() {
        let key = #function
         UserDefaults.standard.set("nil", forKey: key)
        let preferences = getURL()
        print(preferences)
        let data = try! Data(contentsOf: preferences)
        var plist = try! PropertyListSerialization
            .propertyList(
                from: data,
                options: .mutableContainers,
                format: .none) as! [String:Any]
        let expect = "changeBySwift"
        XCTAssertNotNil(plist[key])
        plist[key] = expect
        let toSaveData = try! PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: .max)
        try! toSaveData.write(to: preferences)
        let result = UserDefaults.standard.object(forKey: key) as! String
        XCTAssertEqual(result, expect)
    }
}

private func getURL() -> URL
{
    guard
        let bundleID = Bundle.main.bundleIdentifier,
        let preferences = try? FileManager.default
            .url(for: .libraryDirectory,
                 in: .userDomainMask,
                 appropriateFor: .none,
                 create: false)
            .appendingPathComponent("Preferences/\(bundleID).plist")
        else
    {
        fatalError("Could not find the preferences folder.")
        
    }
    return preferences
}

