//
//  ScanDocValidationRequest.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

// MARK: - ScanDocValidationRequest
struct ScanDocValidationRequest: Codable {
    let acceptTermsAndConditions: Bool
    let dataFields: ValidationDataFields
    let settings: ValidationSettings

    enum CodingKeys: String, CodingKey {
        case acceptTermsAndConditions = "AcceptTermsAndConditions"
        case dataFields = "DataFields"
        case settings = "Settings"
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

// MARK: - DataFields
struct ValidationDataFields: Codable {
    let images: [String]
    let blurValues: [Double]

    enum CodingKeys: String, CodingKey {
        case images = "Images"
        case blurValues = "BlurValues"
    }
}

// MARK: - Settings
struct ValidationSettings: Codable {
    let skipImageSizeCheck: Bool

    enum CodingKeys: String, CodingKey {
        case skipImageSizeCheck = "SkipImageSizeCheck"
    }
}
