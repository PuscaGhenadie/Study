//
//  SecurityStudyTests.swift
//  SecurityStudyTests
//
//  Created by Pusca Ghenadie on 02/04/2019.
//  Copyright © 2019 Pusca Ghenadie. All rights reserved.
//

import XCTest
@testable import SecurityStudy

class SecurityStudyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveToKeychain_errorThrownOnEmpty() {
        let sut = KeychainWrapper()
        
        XCTAssertThrowsError(try sut.save(value: "", forKey: ""))
    }
    
    func testSaveToKeychain_success() {
        let sut = KeychainWrapper()
        
        // TODO: invesitgate -34018 error
        XCTAssertNoThrow(try sut.save(value: "John Doe", forKey: "name"))
    }
    
    func testDeleteFromKechain_success() {
        let sut = KeychainWrapper()
        
        sut.save(value: "IAmBatman", forKey: "key")
        XCTAssertNoThrow(try sut.removeValue(forKey: "key"))
    }
    
    func testGet_success() {
        let sut = KeychainWrapper()
        
        sut.save(value: "IAmBatman", forKey: "key")
        XCTAssertNoThrow(try sut.getValue(forKey: "key"))
    }
}
