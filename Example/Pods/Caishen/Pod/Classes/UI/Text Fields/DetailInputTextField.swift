//
//  DetailInputTextField.swift
//  Caishen
//
//  Created by Daniel Vancura on 3/9/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 A text field subclass that validates any input for card detail before changing the text attribute.
 You can subclass `DetailInputTextField` and override `isInputValid` to specify the validation routine.
 The default implementation accepts any input.
 */
open class DetailInputTextField: StylizedTextField, TextFieldValidation, AutoCompletingTextField {
    
    open weak var cardInfoTextFieldDelegate: CardInfoTextFieldDelegate?
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            textField.text = UITextField.emptyTextFieldCharacter
        }
    }
    
    open override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: (textField.text ?? "")).replacingCharacters(in: range, with: string).replacingOccurrences(of: UITextField.emptyTextFieldCharacter, with: "")
        
        let deletingLastCharacter = !(textField.text ?? "").isEmpty && textField.text != UITextField.emptyTextFieldCharacter && newText.isEmpty
        if deletingLastCharacter {
            textField.text = UITextField.emptyTextFieldCharacter
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: newText)
            return false
        }
        
        let autoCompletedNewText = autocomplete(newText)
        
        let (currentTextFieldText, overflowTextFieldText) = split(autoCompletedNewText)
        
        if isInputValid(currentTextFieldText, partiallyValid: true) {
            textField.text = currentTextFieldText
            if isInputValid(currentTextFieldText, partiallyValid: false) {
                cardInfoTextFieldDelegate?.textField(self, didEnterValidInfo: currentTextFieldText)
            } else {
                cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: currentTextFieldText)
            }
        }
        
        if !overflowTextFieldText.isEmpty {
            cardInfoTextFieldDelegate?.textField(self, didEnterOverflowInfo: overflowTextFieldText)
        }
        
        return false
    }
    
    open func prefill(_ text: String) {
        if isInputValid(text, partiallyValid: false) {
            self.text = text
            cardInfoTextFieldDelegate?.textField(self, didEnterValidInfo: text)
        } else if isInputValid(text, partiallyValid: true) {
            self.text = text
            cardInfoTextFieldDelegate?.textField(self, didEnterPartiallyValidInfo: text)
        }
    }

    /**
     Default number of expected digits for MonthInputTextField and YearInputTextField
     */
    var expectedInputLength: Int {
        return 2
    }

    func isInputValid(_ input: String, partiallyValid: Bool) -> Bool {
        return true
    }

    func autocomplete(_ text: String) -> String {
        return text
    }
    
    private func split(_ text: String) -> (currentText: String, overflowText: String) {
        let hasOverflow = text.count > expectedInputLength
        let index = (hasOverflow) ?
            text.index(text.startIndex, offsetBy: expectedInputLength) :
            text.index(text.startIndex, offsetBy: text.count)
        return (String(text[..<index]), String(text[index...]))
    }
}
