//
//  UITextField+Extensions.swift
//  Pods
//
//  Created by Christopher Jones on 3/24/16.
//
//

import UIKit

internal extension UITextField {

    /**
     A very short empty text character. Methods like `textField: shouldChangeCharactersInRange:` or `deleteBackward` aren't called if the text field is empty (the latter is called - but only when entered from a hardware keyboard). 
     Therefor, this character is inserted into empty text fields and as soon as the user hits backspace, the character gets deleted. This causes `text.characters.count` to become 0, which is used as condition to go to the previous text field.
     
     - note: This character was chosen in favor of other (even shorter) empty text characters, which caused unexpected behavior when used in a right-aligned text field (the cursor jumped to the left when starting editing).
     */
    internal static var emptyTextFieldCharacter: String {
        return "\u{202F}"
    }
}

