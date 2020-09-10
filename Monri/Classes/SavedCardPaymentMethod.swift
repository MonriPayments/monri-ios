//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class SavedCardPaymentMethod: SavedPaymentMethod {
    public let type: String
    public let data: Dictionary<String, String>
    public let parsedData: SavedCardPaymentMethodData

    init(type: String, data: SavedCardPaymentMethodData) {
        self.type = type
        self.data = data.toJSON()
        self.parsedData = data
    }

    static func fromJson(_ json: Dictionary<String, Any>) -> SavedCardPaymentMethod? {

        guard let type = json["type"] as? String else {
            return nil
        }

        if (type != "card") {
            return nil
        }

        guard let data = SavedCardPaymentMethodData.fromJson(json["data"] as? Dictionary<String, Any>) else {
            return nil
        }

        return SavedCardPaymentMethod(type: type, data: data)
    }
}

public struct SavedCardPaymentMethodData {
    public let brand: String
    public let issuer: String
    public let masked: String
    public let expirationDate: String
    public let token: String

    public init(brand: String, issuer: String, masked: String, expirationDate: String, token: String) {
        self.brand = brand
        self.issuer = issuer
        self.masked = masked
        self.expirationDate = expirationDate
        self.token = token
    }

    static func fromJson(_ json: Dictionary<String, Any>?) -> SavedCardPaymentMethodData? {
        guard let json = json else {
            return nil
        }
        return SavedCardPaymentMethodData(
                brand: json["brand"] as! String,
                issuer: json["issuer"] as! String,
                masked: json["masked"] as! String,
                expirationDate: "\(json["expiration_date"]!)",
                token: json["token"] as! String
        );
    }

    public func toJSON() -> Dictionary<String, String> {
        [
            "brand": brand,
            "issuer": issuer,
            "masked": masked,
            "expiration_date": expirationDate,
            "token": token
        ]
    }

}
