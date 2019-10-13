//
//  ConcurrencyTestTests.swift
//  ConcurrencyTestTests
//


import XCTest
@testable import ConcurrencyTest

class ConcurrencyTests: XCTestCase {
    func testloadMessage() {
        
        let fetchMessage = FetchMessages()
        
        //Defined expectation
        let expec = expectation(description: "loadMessage executes and runs the callback closure")
        
        fetchMessage.loadMessage { (message, executionTime)  in
    
        executionTime < 2.0 ? XCTAssertEqual(message, "Good morning!") : XCTAssertEqual(message, "Unable to load message - Time out exceeded")
        
            //fulfill the expectation.
            expec.fulfill()
        }
        
        //Execution timeout behaviour
        self.waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout error: \(error)")
            }
        }
    }
}
