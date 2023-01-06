//
//  ViewController.swift
//  Monri
//
//  Created by jasmin.suljic on 10/31/2019.
//  Copyright (c) 2019 jasmin.suljic. All rights reserved.
//

import UIKit
import Monri

class ViewController: UIViewController {

    // TODO: replace with your merchant's authenticity monriToken
    let authenticityToken = "6a13d79bde8da9320e88923cb3472fb638619ccb";
    //TODO: replace with your merchant's merchant key
    let merchantKey = "TestKeyXULLyvgWyPJSwOHe";

    let accessToken = "Bearer eyJhbGciOiJSUzI1NiJ9.eyJzY29wZXMiOlsiY3VzdG9tZXJzIiwicGF5bWVudC1tZXRob2RzIl0sImV4cCI6MTY3MjQyMDkwMSwiaXNzIjoiaHR0cHM6Ly9tb25yaS5jb20iLCJzdWIiOiI2YTEzZDc5YmRlOGRhOTMyMGU4ODkyM2NiMzQ3MmZiNjM4NjE5Y2NiIn0.RsVUAr2mPcFiG84jBMHDKWnHyP2JENa4BamvyjTPVuO1sjUBZvNt7cS0TZ6kTbb1KI1bxoQh1rPX8N3FurvSX3wNQVITDMDmQp6Cgi6oaQEc1v39uqM9S-iyS6TX2A9JPI12oa1D4-QCwEeMe-d97S2XWA4fAKVNkmXNipnTAMpxdt2owrbxh3Ml5qhYg9_D7PH3fyfgkKxG8F705YdDYaEZhO0BkoBj5dAz0tenBMUPdzLagGoEi-hS90DwHBjAwgeCKbHumJybVY23ta4orosTlR7HX_6wJw5ouaeqZ4Bf8bhvDST7yaL6IcmEoMmOX5DNsaMPYqUBIWQpz52kLA"

    lazy var monri: MonriApi = {
        [unowned self] in
        return MonriApi(self.navigationController!, options: MonriApiOptions(authenticityToken: authenticityToken, developmentMode: true));
    }()

    var repository: OrdersRepository {
        OrdersRepository(authenticityToken: authenticityToken)
    }

    @IBOutlet weak var cardInlineView: CardInlineView!

    @IBOutlet weak var saveCardForFuturePaymentsSwitch: UISwitch!

    let merchantId = "\(Int(NSDate().timeIntervalSince1970))"
    var createdCustomer: CustomerResponse? = nil

    @IBAction func createCustomer(_ sender: Any) {
        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId,
                description: "description",
                email: "adnan.omerovic@monri.com",
                name: "Adnan",
                phone: "00387000111",
                metadata: ["a": "b", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        let customerRequest = CustomerCreateRequest(accessToken: accessToken, customerRequestBody: customerRequestBody)

        monri.createCustomer(customerRequest) { (result: CustomerResponseResult) in

            switch (result) {
            case .result(let customerResponse):
                self.createdCustomer = customerResponse
                print("customer response\(customerResponse.email)")
                print("customer response\(customerResponse.name)")
            case .error(let customerError):
                print("customer error\(customerError)")
            }

        }
    }

    @IBAction func updateCustomer(_ sender: Any) {
        guard let createdCustomer = createdCustomer else {
            return
        }

        let customerRequestBody = CustomerRequestBody(
                merchantCustomerId: merchantId, //todo this is not necessary
                description: "description",
                email: "adnan.omerovic.updated@monri.com",
                name: "Adnan Updated",
                phone: "00387000111",
                metadata: ["Updated at": "\(NSDate().timeIntervalSince1970)", "c": "d"],
                zipCode: "71000",
                city: "Sarajevo",
                address: "Džemala Bijedića 2",
                country: "BA"
        )

        let customerUpdateRequest = CustomerUpdateRequest(
                customerRequestBody: customerRequestBody,
                customerUuid: createdCustomer.uuid,
                accessToken: accessToken
        )

        monri.updateCustomer(customerUpdateRequest) { (result: CustomerResponseResult) in
            switch (result) {
            case .result(let customerUpdateResponse):
                print("customer update response\(customerUpdateResponse.name)")
                print("customer update response\(customerUpdateResponse.metadata)")
            case .error(let customerUpdateError):
                print("customer update error\(customerUpdateError)")
            }

        }
    }


    @IBAction func deleteCustomer(_ sender: Any) {
        guard let createdCustomer = createdCustomer else {
            return
        }

        let customerDeleteRequest = CustomerDeleteRequest(
                customerUuid: createdCustomer.uuid,
                accessToken: accessToken
        )
        monri.deleteCustomer(customerDeleteRequest) { result in
            switch (result) {
            case .result(let customerDeleteResponse):
                print("customer delete response\(customerDeleteResponse.deleted)")
            case .error(let message):
                print("customer update error\(message)")
            }
        }
    }


    @IBAction func retrieveCustomer(_ sender: Any) {
        guard let createdCustomer = createdCustomer else {
            return
        }

        let customerRetrieveRequest = CustomerRetrieveRequest(
                accessToken: accessToken,
                customerUuid: createdCustomer.uuid
        )

        monri.retrieveCustomer(customerRetrieveRequest) { result in
            switch (result) {
            case .result(let customerResponse):
                print("customer retrieve response\(customerResponse.city)")
            case .error(let message):
                print("customer retrieve error\(message)")
            }
        }
    }


    @IBAction func retrieveCustomerViaMerchantId(_ sender: Any) {
        guard let createdCustomer = createdCustomer else {
            return
        }

        let customerRetrieveMerchantIdRequest = CustomerRetrieveMerchantIdRequest(
                accessToken: accessToken,
                merchantCustomerUuid: createdCustomer.merchantCustomerId
        )

        monri.retrieveCustomerViaMerchantId(customerRetrieveMerchantIdRequest) { result in
            switch (result) {
            case .result(let customerResponse):
                print("customer retrieve response\(customerResponse.city)")
            case .error(let message):
                print("customer retrieve error\(message)")
            }
        }
    }


    @IBAction func getAllCustomers(_ sender: Any) {
        monri.retrieveAllCustomers(accessToken){ result in
            switch (result) {
            case .result(let customerAllResponse):
                print("All customers response: \(customerAllResponse.status)")
                if(!customerAllResponse.customerResponseArray.isEmpty){
                    let firstCustomer = customerAllResponse.customerResponseArray[0]
                    print("All customers response first customer email: \(firstCustomer.email)")
                }
            case .error(let message):
                print("retrieve customers error\(message)")
            }
        }
    }


    @IBAction func retrieveSavedCardsFromCustomer(_ sender: Any) {
        guard let createdCustomer = createdCustomer else {
            return
        }

        let request = CustomerPaymentMethodRequest(
                customerUuid: createdCustomer.uuid,
                limit: 20,
                offset: 0,
                accessToken: accessToken
        )

        monri.getPaymentMethodsForCustomer(request) { result in
            switch (result) {
            case .result(let paymentMethodResponse):
                print("customer retrieve response\(paymentMethodResponse.status)")
            case .error(let message):
                print("customer retrieve error\(message)")
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func confirmPayment(sender: UIButton) {

        var card = cardInlineView.getCard()

        // Save card for future payments
        card.tokenizePan = saveCardForFuturePaymentsSwitch.isOn

        if (!card.validateCard()) {
            alert("Card validation failed")
            return
        }

        repository.createPayment { response in
            guard let response = response else {
                return
            }

            let customerParams: CustomerParams = CustomerParams(
                    customerUuid: self.createdCustomer?.uuid,
                    email: "tester+ios_sdk@monri.com",
                    fullName: "Test iOS",
                    address: "Address",
                    city: "Sarajevo",
                    zip: "71000",
                    phone: "+38761000111",
                    country: "BA"
            )

            let confirmPaymentParams = ConfirmPaymentParams(
                    paymentId: response.clientSecret,
                    paymentMethod: card.toPaymentMethodParams(),
                    transaction: TransactionParams.create().set(customerParams: customerParams)
                            .set("order_info", "iOS SDK payment session")
            )

            self.monri.confirmPayment(confirmPaymentParams) { result in
                switch (result) {
                case .result(let r):
                    self.alert("Transaction \(r.status)")
                    print("\(r)")
                case .error(let e):
                    self.alert("Transaction error \(e)")
                    print("\(e)")
                case .declined(let d):
                    self.alert("Transaction declined \(d.status)")
                    print("\(d)")
                case .pending:
                    self.alert("Transaction pending")
                    print("trx pending")
                }
            }
        }

        if (false) {
            let date = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            let timestamp = formatter.string(from: date);
            let token = UUID.init().uuidString
            // merchantKey, token, timestamp
            let digest = "\(merchantKey)\(token)\(timestamp)".sha512
            let tokenRequest = TokenRequest(token: token, digest: digest, timestamp: timestamp)

            var card = cardInlineView.getCard()

            // Save card for future payments
            card.tokenizePan = saveCardForFuturePaymentsSwitch.isOn

            if !card.validateCard() {
                print("Card validation failed")
                print("card.number valid = \(card.validateNumber())")
                print("card.cvv valid = \(card.validateCVC())")
                print("card.exp_date valid = \(card.validateExpiryDate())")
                // Card validation failed
            } else {
                print("Card last4: \(card.last4)")
                if let type = card.type {
                    print("Card type: \(type)")
                }

                //            let paymentMethod = SavedCard(
                //                panToken: "cafb28787e42aadcd73a7e92e5e57fa2b504280b40a26e75c00c62ec4c6f0a15",
                //                cvc: "123"
                //            )

                monri.createToken(tokenRequest, paymentMethod: card) {
                    result in
                    switch result {
                    case .error(let error):
                        print("An error occurred \(error)")
                    case .token(let token):
                        print("Token received \(token)")
                    }
                }
            }
        }


    }

    func non3DSCard() -> PaymentMethodParams {
        return Card(number: "4111 1111 1111 1111", cvc: "123", expMonth: 10, expYear: 2027).toPaymentMethodParams()
    }

    func threeDSCard() -> PaymentMethodParams {
        return Card(number: "4341 7920 0000 0044", cvc: "123", expMonth: 10, expYear: 2027).toPaymentMethodParams()
    }

    func alert(_ message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

