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

    lazy var monri: MonriApi = {
        [unowned self] in
        return MonriApi(self.navigationController!, authenticityToken: authenticityToken);
    }()

    var repository: OrdersRepository {
        OrdersRepository(authenticityToken: authenticityToken)
    }

    @IBOutlet weak var cardInlineView: CardInlineView!

    @IBOutlet weak var saveCardForFuturePaymentsSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func confirmPayment(sender: UIButton) {
        
        var card = cardInlineView.getCard()

        // Save card for future payments
        card.tokenizePan = saveCardForFuturePaymentsSwitch.isOn
        
        if(!card.validateCard()) {
            alert("Card validation failed")
            return
        }

        repository.createPayment { response in
            guard let response = response else {
                return
            }

            let customerParams: CustomerParams = CustomerParams(
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
                    paymentMethod: self.threeDSCard(),
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

    func non3DSCard() -> PaymentMethodParams{
        return Card(number: "4111 1111 1111 1111", cvc: "123", expMonth: 10, expYear: 2027).toPaymentMethodParams()
    }

    func threeDSCard() -> PaymentMethodParams{
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

