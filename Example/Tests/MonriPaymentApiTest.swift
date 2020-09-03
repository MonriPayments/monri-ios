//
// Created by Jasmin Suljic on 03/09/2020.
// Copyright (c) 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Monri

class MonriPaymentApiTest: XCTestCase {

    var monriPaymentApi: MonriPaymentApi!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        monriPaymentApi = MonriFactory().createPaymentApi(options: MonriApiOptions(authenticityToken: "6a13d79bde8da9320e88923cb3472fb638619ccb", developmentMode: true))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        expect(true).to(equal(true))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
