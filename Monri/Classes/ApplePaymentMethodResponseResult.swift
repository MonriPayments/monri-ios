//
//  ApplePaymentMethodResponseResult.swift
//  Pods
//
//  Created by Karolina Škunca on 17.06.2025..
//


public typealias ApplePaymentMethodResponseCallback = (CustomerPaymentMethodResponseResult) -> Void

public enum ApplePaymentMethodResponseResult {
    case result(ApplePaymentInfo)
    case error(ApplePaymentApiError)
}

public struct ApplePaymentInfo: Codable {
    public let countryCode, currencyCode: String
    public let supportedNetworks, merchantCapabilities: [String]
    public let total: Total

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case currencyCode = "currency_code"
        case supportedNetworks = "supported_networks"
        case merchantCapabilities = "merchant_capabilities"
        case total
    }
    
    static func fromJson(_ json: [String: Any]?) -> ApplePaymentInfo? {
        guard let json = json else {
            print("StartApplePayResponse: Input JSON is nil")
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let decoded = try JSONDecoder().decode(ApplePaymentInfo.self, from: data)
            return decoded
        } catch {
            print("StartApplePayResponse decoding failed: \(error)")
            return nil
        }
    }
}

// MARK: - Total
public struct Total: Codable {
    public let label, amount: String
}
