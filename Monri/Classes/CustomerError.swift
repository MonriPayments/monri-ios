//
//  CusomerError.swift
//  Monri
//
//  Created by Adnan Omerovic on 15. 12. 2022..
//

import Foundation

public enum CustomerError: Error  {
    case requestFailed(String)
    case customerFailed
    case jsonParsingError(String)
    case unknownError(Error)
}
