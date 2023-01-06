//
//  MonriPaymentsCustomerApiTest.swift
//  Monri_Tests
//
//  Created by Adnan Omerovic on 4. 1. 2023..
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import Monri
import Alamofire

final class MonriPaymentsCustomerApiTest: XCTestCase {
    let authenticityToken = "6a13d79bde8da9320e88923cb3472fb638619ccb";

    static let non3DSCard = Card(number: "4111 1111 1111 1111", cvc: "123", expMonth: 10, expYear: 2031, tokenizePan: true).toPaymentMethodParams()

    lazy var monri: MonriApi = {
        [unowned self] in
        let viewController = UIViewController()
        return MonriApi(viewController, options: MonriApiOptions(authenticityToken: authenticityToken, developmentMode: true));
    }()

    lazy var monriHttpApi: MonriHttpApi = {
        return MonriFactory().createHttpApi(options: MonriApiOptions(authenticityToken: authenticityToken, developmentMode: true))
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    private func createPayment(_ callback: @escaping (String?, String?) -> Void) {
        Alamofire.request("https://mobile.webteh.hr/example/create-payment-session", method: .post, parameters: [:], encoding: JSONEncoding.default)
                .responseJSON { dataResponse in
                    guard let data = dataResponse.data else {
                        callback(nil, nil)
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            callback(nil, nil)
                            return
                        }

                        callback(json["client_secret"] as? String, json["status"] as? String)
                    } catch {
                        callback(nil, nil)
                    }
                }
    }


    func createPaymentAccessToken(_ callback: @escaping (String) -> Void) {
        callback("Bearer eyJhbGciOiJSUzI1NiJ9.eyJzY29wZXMiOlsiY3VzdG9tZXJzIiwicGF5bWVudC1tZXRob2RzIl0sImV4cCI6MTY3MzAyMDYwNSwiaXNzIjoiaHR0cHM6Ly9tb25yaS5jb20iLCJzdWIiOiI2YTEzZDc5YmRlOGRhOTMyMGU4ODkyM2NiMzQ3MmZiNjM4NjE5Y2NiIn0.PXRKL5Y9CpEVfs3YC7hM5yMU9bS5dFMicr5W3ZWtW1gew53hZsONEzm-QhAnn1XI6rqzU8-jmgtbc61UIj1JcA7goGKKrUJpSalEo4Zv4xdsZXVUES-LjF0mvTFzohgAqcGtWf2LMJUHhrUXpDUXVv67KDSRehT2ND2OQIS1KarHNC6LbZqKiAAG9aeAa5AVpT9Yy7iGCdpqNuxxUxtqCma5DyXwbDTRV8lBN-QD_WIGUfIRa0jL96wc-SJEXMHvwQVP_xlZSYc8bFVSvPQOspOnbJVzUkKoSErXIBUlYLPMsbGrsSS_tg_ie4mX7Mu-uQmEaVH3E7eznzCnIioa2A")
    }

    func testCreateCustomer() throws {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerResponse: CustomerResponseResult?
        let expectation = self.expectation(description: "testCreateCustomer")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                customerResponse = result
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        switch customerResponse {
        case .result(let customerResponse):
            XCTAssertNotNil(customerResponse)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.merchantCustomerId, customerResponse.merchantCustomerId)
            XCTAssertEqual(customerRequestBody.description, customerResponse.description)
            XCTAssertEqual(customerRequestBody.email, customerResponse.email)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.phone, customerResponse.phone)
            XCTAssertEqual(customerRequestBody.metadata, customerResponse.metadata)
            XCTAssertEqual(customerRequestBody.zipCode, customerResponse.zipCode)
            XCTAssertEqual(customerRequestBody.city, customerResponse.city)
            XCTAssertEqual(customerRequestBody.address, customerResponse.address)
            XCTAssertEqual(customerRequestBody.country, customerResponse.country)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been created")
        }
    }


    func testUpdateCustomer() throws {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerUpdateResponse: CustomerResponseResult?


        let expectation = self.expectation(description: "testUpdateCustomer")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                switch result {
                case .result(let customerResponse):
                    XCTAssertNotNil(customerResponse)
                    let customerUpdateRequest = CustomerUpdateRequest(
                            customerRequestBody: customerRequestBody
                                    .setName("Adnan Update")
                                    .setEmail("email.update@monri.com"),
                            customerUuid: customerResponse.uuid,
                            accessToken: accessToken
                    )
                    self.monri.updateCustomer(customerUpdateRequest) { (result: CustomerResponseResult) in
                        customerUpdateResponse = result
                        expectation.fulfill()
                    }
                case .error(let customerError):
                    XCTFail("\(customerError)")
                }

            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        switch customerUpdateResponse {
        case .result(let customerResponse):
            XCTAssertNotNil(customerResponse)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.merchantCustomerId, customerResponse.merchantCustomerId)
            XCTAssertEqual(customerRequestBody.description, customerResponse.description)
            XCTAssertEqual(customerRequestBody.email, customerResponse.email)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.phone, customerResponse.phone)
            XCTAssertEqual(customerRequestBody.metadata, customerResponse.metadata)
            XCTAssertEqual(customerRequestBody.zipCode, customerResponse.zipCode)
            XCTAssertEqual(customerRequestBody.city, customerResponse.city)
            XCTAssertEqual(customerRequestBody.address, customerResponse.address)
            XCTAssertEqual(customerRequestBody.country, customerResponse.country)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been updated")
        }
    }


    func testDeleteCustomer() throws {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic@monri.com",
                name: "Adnan delete",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerDeleteResponse: CustomerDeleteResult?
        var customerCreateResponse: CustomerResponse?


        let expectation = self.expectation(description: "testDeleteCustomer")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                switch result {
                case .result(let customerResponse):
                    XCTAssertNotNil(customerResponse)
                    customerCreateResponse = customerResponse
                    let customerDeleteRequest = CustomerDeleteRequest(
                            customerUuid: customerResponse.uuid,
                            accessToken: accessToken
                    )
                    self.monri.deleteCustomer(customerDeleteRequest) { (result: CustomerDeleteResult) in
                        customerDeleteResponse = result
                        expectation.fulfill()
                    }
                case .error(let customerError):
                    XCTFail("\(customerError)")
                }

            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        switch customerDeleteResponse {
        case .result(let customerDeleteResponse):
            XCTAssertNotNil(customerDeleteResponse)
            XCTAssertEqual(customerDeleteResponse.deleted, true)
            XCTAssertEqual(customerDeleteResponse.status, "approved")
            XCTAssertEqual(customerDeleteResponse.uuid, customerCreateResponse?.uuid)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been deleted")
        }
    }

    func testRetrieveCustomer() throws {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerUpdateResponse: CustomerResponseResult?

        let expectation = self.expectation(description: "testRetrieveCustomer")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                switch result {
                case .result(let customerResponse):
                    XCTAssertNotNil(customerResponse)
                    let customerRetrieveRequest = CustomerRetrieveRequest(
                            accessToken: accessToken,
                            customerUuid: customerResponse.uuid
                    )
                    self.monri.retrieveCustomer(customerRetrieveRequest) { (result: CustomerResponseResult) in
                        customerUpdateResponse = result
                        expectation.fulfill()
                    }
                case .error(let customerError):
                    XCTFail("\(customerError)")
                }

            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        switch customerUpdateResponse {
        case .result(let customerResponse):
            XCTAssertNotNil(customerResponse)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.merchantCustomerId, customerResponse.merchantCustomerId)
            XCTAssertEqual(customerRequestBody.description, customerResponse.description)
            XCTAssertEqual(customerRequestBody.email, customerResponse.email)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.phone, customerResponse.phone)
            XCTAssertEqual(customerRequestBody.metadata, customerResponse.metadata)
            XCTAssertEqual(customerRequestBody.zipCode, customerResponse.zipCode)
            XCTAssertEqual(customerRequestBody.city, customerResponse.city)
            XCTAssertEqual(customerRequestBody.address, customerResponse.address)
            XCTAssertEqual(customerRequestBody.country, customerResponse.country)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been retrieved")
        }
    }

    func testRetrieveCustomerViaMerchantId() throws {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerUpdateResponse: CustomerResponseResult?

        let expectation = self.expectation(description: "testRetrieveCustomerViaMerchantId")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                switch result {
                case .result(let customerResponse):
                    XCTAssertNotNil(customerResponse)
                    let customerRetrieveRequest = CustomerRetrieveMerchantIdRequest(
                            accessToken: accessToken,
                            merchantCustomerUuid: customerResponse.merchantCustomerId
                    )
                    self.monri.retrieveCustomerViaMerchantId(customerRetrieveRequest) { (result: CustomerResponseResult) in
                        customerUpdateResponse = result
                        expectation.fulfill()
                    }
                case .error(let customerError):
                    XCTFail("\(customerError)")
                }

            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        switch customerUpdateResponse {
        case .result(let customerResponse):
            XCTAssertNotNil(customerResponse)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.merchantCustomerId, customerResponse.merchantCustomerId)
            XCTAssertEqual(customerRequestBody.description, customerResponse.description)
            XCTAssertEqual(customerRequestBody.email, customerResponse.email)
            XCTAssertEqual(customerRequestBody.name, customerResponse.name)
            XCTAssertEqual(customerRequestBody.phone, customerResponse.phone)
            XCTAssertEqual(customerRequestBody.metadata, customerResponse.metadata)
            XCTAssertEqual(customerRequestBody.zipCode, customerResponse.zipCode)
            XCTAssertEqual(customerRequestBody.city, customerResponse.city)
            XCTAssertEqual(customerRequestBody.address, customerResponse.address)
            XCTAssertEqual(customerRequestBody.country, customerResponse.country)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been retrieved")
        }
    }

//    func confirmPayment(
//            card: PaymentMethodParams = MonriPaymentApiTest.non3DSCard,
//            customerParams: CustomerParams,
//            _ callback: @escaping (_ error: String?, _ paymentResult: PaymentResult?) -> Void
//    ) {
//        createPayment { clientSecret, status in
//            guard status != nil else {
//                callback("Payment create failed", nil)
//                return
//            }
////
//            guard let clientSecret = clientSecret else {
//                callback("Payment create failed", nil)
//                return
//            }
//
//            let params = ConfirmPaymentParams(paymentId: clientSecret,
//                    paymentMethod: card,
//                    transaction: TransactionParams.create()
//                            .set(customerParams: customerParams)
//                            .set("order_info", "iOS SDK payment session")
//            )
//
//            self.monri.confirmPayment(params) { result in
//                switch (result) {
//                case .result(let tmpPaymentResult):
//                    callback(nil, tmpPaymentResult)
//                case .error(let e):
//                    callback("\(e)", nil)
//                case .declined(let d):
//                    callback("\(d)", nil)
//                case .pending:
//                    callback("transaction is in pending status", nil)
//                }
//            }
//        }
//
//    }

    func confirmPayment(card: PaymentMethodParams = non3DSCard,
                        customerParams: CustomerParams,
                        _ callback: @escaping (_ error: String?, _ clientSecret: String?, _ response: ConfirmPaymentResponse?) -> Void) {

        createPayment { clientSecret, status in

            guard status != nil else {
                callback("Payment create failed", nil, nil)
                return
            }

            guard let clientSecret = clientSecret else {
                callback("Payment create failed", nil, nil)
                return
            }

            let params = ConfirmPaymentParams(paymentId: clientSecret,
                    paymentMethod: card,
                    transaction: TransactionParams.create()
                            .set(customerParams: customerParams)
                            .set("order_info", "iOS SDK payment session")
            )

            self.monriHttpApi.confirmPayment(params) { confirmPayment in
                switch (confirmPayment) {
                case .error(let e):
                    callback("Confirm payment error \(e)", nil, nil)
                case .unknownError(let e):
                    callback("Confirm payment error \(e)", nil, nil)
                case .result(let r):
                    callback(nil, clientSecret, r)
                case .pending:
                    callback("Confirm payment pending", nil, nil)
                }
            }
        }
    }

    func testPayment() {
        let merchantId = UUID().uuidString
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        var customerResponse2: CustomerResponse?

        let expectation0 = self.expectation(description: "testCreateCustomer")

        createPaymentAccessToken { accessToken in
            let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)
            self.monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in
                switch result {
                case .result(let customerResponse):
                    XCTAssertNotNil(customerResponse)
                    customerResponse2 = customerResponse
                    expectation0.fulfill()
                case .error(let customerError):
                    XCTFail("\(customerError)")
                    expectation0.fulfill()
                }

            }
        }
        waitForExpectations(timeout: 5, handler: nil)

        let customerParams = CustomerParams(
                customerUuid: customerResponse2?.uuid,
                email: customerRequestBody.email,
                fullName: customerRequestBody.name,
                address: customerRequestBody.address,
                city: customerRequestBody.city,
                zip: customerRequestBody.zipCode,
                phone: customerRequestBody.phone,
                country: customerRequestBody.country
        )

        let expectation1 = self.expectation(description: "testPaymentStatus")
        confirmPayment(customerParams: customerParams) { errorResult, clientSecretResult, responseResult in
            XCTAssertEqual(PaymentStatus.approved, responseResult?.status)
            expectation1.fulfill()
        }

        waitForExpectations(timeout: 15, handler: nil)

        var customerPaymentMethodResponseResult: CustomerPaymentMethodResponseResult?
        let expectation2 = self.expectation(description: "testRetrievePaymentMethod")

        createPaymentAccessToken { accessToken in
            let customerPaymentMethodRequest = CustomerPaymentMethodRequest(
                    customerUuid: customerResponse2?.uuid ?? "",
                    limit: 25,
                    offset: 0,
                    accessToken: accessToken
            )
            self.monri.getPaymentMethodsForCustomer(customerPaymentMethodRequest) { (result: CustomerPaymentMethodResponseResult) in
                customerPaymentMethodResponseResult = result
                expectation2.fulfill()
            }
        }
        waitForExpectations(timeout: 25, handler: nil)

        switch customerPaymentMethodResponseResult {
        case .result(let customerPaymentMethodResponse):
            XCTAssertNotNil(customerPaymentMethodResponse)
            XCTAssertNotNil(customerPaymentMethodResponse.customerPaymentMethod)
            let paymentMethod = customerPaymentMethodResponse.customerPaymentMethod[0]
            XCTAssertEqual("411111******1111", paymentMethod.maskedPan)
            XCTAssertNotNil(paymentMethod.token)
            XCTAssertEqual(false, paymentMethod.expired)
            XCTAssertEqual("2031-10-31", paymentMethod.expirationDate)
            XCTAssertEqual(customerParams.customerUuid, paymentMethod.customerUuid)
        case .error(let customerError):
            XCTFail("\(customerError)")
        case .none:
            XCTFail("customer has not been retrieved")
        }

    }


}
