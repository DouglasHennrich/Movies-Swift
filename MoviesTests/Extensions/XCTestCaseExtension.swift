//
//  XCTestCaseExtension.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import XCTest

// swiftlint:disable force_try
extension XCTestCase {
    
    func loadSub(name: String, extensionName: String) -> Data {
        // Obtain Reference to Bundle
        let bundle = Bundle(for: type(of: self))

        // Ask Bundle for URL of Stub
        let url = bundle.url(forResource: name, withExtension: extensionName)

        // Use URL to Create Data Object
        return try! Data(contentsOf: url!)
    }
    
}
