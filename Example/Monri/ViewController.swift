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
        return MonriApi(authenticityToken: authenticityToken);
    }()
    
    @IBOutlet weak var cardInlineView: CardInlineView!
    
    @IBOutlet weak var saveCardForFuturePaymentsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmPayment(sender: UIButton) {
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
            
            monri.createToken(tokenRequest, card: card) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

