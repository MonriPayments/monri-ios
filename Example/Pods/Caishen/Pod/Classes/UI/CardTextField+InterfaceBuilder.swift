//
//  CardTextField+InterfaceBuilder.swift
//  Caishen
//
//  Created by Daniel Vancura on 3/8/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

extension CardTextField {
    override public final var textColor: UIColor? {
        didSet {
            let textFieldArray: [UITextField?] = [numberInputTextField, cvcTextField, monthTextField, yearTextField]
            textFieldArray.forEach({$0?.textColor = textColor})
        }
    }
    override public final var backgroundColor: UIColor? {
        didSet {
            numberInputTextField?.backgroundColor = backgroundColor
        }
    }
    override public final var font: UIFont? {
        didSet {
            let textFieldArray: [UITextField?] = [numberInputTextField, cvcTextField, monthTextField, yearTextField]
            textFieldArray.forEach({$0?.font = font})
        }
    }
    override public final var keyboardType: UIKeyboardType {
        didSet {
            let textFieldArray: [UITextField?] = [numberInputTextField, cvcTextField, monthTextField, yearTextField]
            textFieldArray.forEach({$0?.keyboardType = keyboardType})
        }
    }
    override public final var isSecureTextEntry: Bool {
        didSet {
            let textFieldArray: [UITextField?] = [numberInputTextField, cvcTextField, monthTextField, yearTextField]
            textFieldArray.forEach({$0?.isSecureTextEntry = isSecureTextEntry})
        }
    }
    override public final var keyboardAppearance: UIKeyboardAppearance {
        didSet {
            let textFieldArray: [UITextField?] = [numberInputTextField, cvcTextField, monthTextField, yearTextField]
            textFieldArray.forEach({$0?.keyboardAppearance = keyboardAppearance})
        }
    }
}
