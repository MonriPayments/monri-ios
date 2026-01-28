//
//  ScanDocRefreshTokenResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocRefreshTokenResponse
struct ScanDocRefreshTokenResponse: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
    static func fromJson(body: [String: Any]) -> ScanDocRefreshTokenResponse? {
        guard let accessToken = body["access_token"] as? String else {
            return nil
        }
        
        return ScanDocRefreshTokenResponse(accessToken: accessToken)
    }
}
