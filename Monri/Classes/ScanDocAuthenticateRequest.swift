//
//  ScanDocAuthenticateRequest.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

// MARK: - ScanDocAuthenticateRequest
struct ScanDocAuthenticateRequest: Codable {
    let userKey, subClient: String
    
    enum CodingKeys: String, CodingKey {
        case userKey = "user_key"
        case subClient = "sub_client"
    }
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        guard let data = try? encoder.encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let jsonDict = jsonObject as? [String: Any] else {
            return [:]
        }
        return jsonDict
    }
}

