//
//  MonriApiOptions.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class MonriApiOptions {
    public let authenticityToken: String
    public let developmentMode: Bool
    public let merchantID: String?
    
    public var apiUrl: String {
        developmentMode ? MonriConfig.TEST_ENV_HOST: MonriConfig.PROD_ENV_HOST
    }
    
    public init(authenticityToken: String, developmentMode: Bool, merchantID: String? = nil) {
        self.authenticityToken = authenticityToken
        self.developmentMode = developmentMode
        self.merchantID = merchantID
    }
}
