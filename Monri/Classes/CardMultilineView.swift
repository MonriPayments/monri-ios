//
//  CardMultilineView.swift
//  Monri
//
//  Created by Jasmin Suljic on 31/10/2019.
//  Copyright © 2019 Monri Payments d.o.o. All rights reserved.
//

import UIKit
import Caishen

typealias CaishenCard = Caishen.Card

class CardMultilineView: UIView, NumberInputTextFieldDelegate, CardInfoTextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cardNumberTextField: NumberInputTextField!
    @IBOutlet weak var monthInputTextField: MonthInputTextField!
    @IBOutlet weak var yearInputTextField: YearInputTextField!
    @IBOutlet weak var cvcInputTextField: CVCInputTextField!
    
    var card: CaishenCard? {
        let number = cardNumberTextField.cardNumber
        let cvc = CVC(rawValue: cvcInputTextField.text ?? "")
        let expiry = Expiry(month: monthInputTextField.text ?? "", year: yearInputTextField.text ?? "")
            ?? Expiry.invalid
        
        let cardType = cardNumberTextField.cardTypeRegister.cardType(for: cardNumberTextField.cardNumber)
        
        if cardType.validate(cvc: cvc).union(cardType.validate(expiry: expiry)).union(cardType.validate(number: number)) == .Valid {
            return CaishenCard(number: number, cvc: cvc, expiry: expiry)
        } else {
            return nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commmonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commmonInit()
    }
    
    private func commmonInit() {
        let bundle = Bundle(for: self.classForCoder)
        bundle.loadNibNamed("CardMultilineView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        cardNumberTextField.numberInputTextFieldDelegate = self
        monthInputTextField.cardInfoTextFieldDelegate = self
        yearInputTextField.cardInfoTextFieldDelegate = self
        cvcInputTextField.cardInfoTextFieldDelegate = self
        
        // Set the `deleteBackwardCallbacks` - closures which are called whenever a user hits
        // backspace on an empty text field.
        monthInputTextField.deleteBackwardCallback = { _ in self.cardNumberTextField.becomeFirstResponder() }
        yearInputTextField.deleteBackwardCallback = { _ in self.monthInputTextField.becomeFirstResponder() }
        cvcInputTextField.deleteBackwardCallback = { _ in self.yearInputTextField.becomeFirstResponder() }
    }
    
    public func numberInputTextFieldDidComplete(_ numberInputTextField: NumberInputTextField) {
        // TODO: contribute to repo README with changes done in this file
        cvcInputTextField.cardType = numberInputTextField.cardTypeRegister.cardType(for: numberInputTextField.cardNumber)
//        print("Card number: \(numberInputTextField.cardNumber)")
//        print(card)
        monthInputTextField.becomeFirstResponder()
    }
    
    public func numberInputTextFieldDidChangeText(_ numberInputTextField: NumberInputTextField) {
        
    }
    
    public func textField(_ textField: UITextField, didEnterValidInfo: String) {
        switch textField {
        case is MonthInputTextField:
            print("Month: \(didEnterValidInfo)")
            yearInputTextField.becomeFirstResponder()
        case is YearInputTextField:
            print("Year: \(didEnterValidInfo)")
            cvcInputTextField.becomeFirstResponder()
        case is CVCInputTextField:
            print("CVC: \(didEnterValidInfo)")
        default:
            break
        }
//        print(card)
    }
    
    public func textField(_ textField: UITextField, didEnterPartiallyValidInfo: String) {
        // The user entered information that is not valid but might become valid on further input.
        // Example: Entering "1" for the CVC is partially valid, while entering "a" is not.
    }
    
    public func textField(_ textField: UITextField, didEnterOverflowInfo overFlowDigits: String) {
        // This function is used in a CardTextField to carry digits to the next text field.
        // Example: A user entered "02/20" as expiry and now tries to append "5" to the month.
        //          On a card text field, the year will be replaced with "5" - the overflow digit.
    }

}
