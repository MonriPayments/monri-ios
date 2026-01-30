//
//  AuthenticateResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocAuthenticateResponse
struct AuthenticateResponse: Codable {
    public let accessToken, refreshToken: String

    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    public static func fromJson(body: [String: Any]) -> AuthenticateResponse? {
        guard let accessToken = body["access_token"] as? String,
              let refreshToken = body["refresh_token"] as? String else {
            return nil
        }
        
        return AuthenticateResponse(accessToken: accessToken, refreshToken: refreshToken)
    }
}
