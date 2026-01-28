//
//  ScanDocRefreshTokenRequest.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocRefreshTokenRequest
struct ScanDocRefreshTokenRequest: Codable {
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
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

