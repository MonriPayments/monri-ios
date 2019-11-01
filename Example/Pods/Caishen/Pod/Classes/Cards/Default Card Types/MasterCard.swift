//
//  MasterCard.swift
//  Caishen
//
//  Created by Daniel Vancura on 2/17/16.
//  Copyright © 2016 Prolific Interactive. All rights reserved.
//

import UIKit

/**
 *  The native supported card type of MasterCard
 */
public struct MasterCard: CardType {
    
    public let name = "MasterCard"

    public let CVCLength = 3

    public let identifyingDigits = Set(51...55).union(2221...2720)

    public init() {
        
    }

}
