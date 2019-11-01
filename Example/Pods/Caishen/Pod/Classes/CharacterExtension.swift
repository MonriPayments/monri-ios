//
//  CharacterExtension.swift
//  Pods
//
//  Created by Daniel Vancura on 4/15/16.
//
//

import Foundation

extension Character {
    
    /**
     - returns: Whether or not `self` is numeric.
     */
    func isNumeric() -> Bool {
        return String(self).isNumeric()
    }
}