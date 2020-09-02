//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class SavedCardPaymentMethod: SavedPaymentMethod {
    let type: String
    let data: Dictionary<String, String>

    init(type: String, data: SavedCardPaymentMethodData) {
        self.type = type
        self.data = data.toJSON()
    }

    static func fromJson(_ json: Dictionary<String, Any>) -> SavedCardPaymentMethod? {

        guard let type = json["type"] as? String else {
            return nil
        }

        if (type != "card") {
            return nil
        }

        guard let data = SavedCardPaymentMethodData.fromJson(json["data"] as? Dictionary<String, String>) else {
            return nil
        }

        return SavedCardPaymentMethod(type: type, data: data)
    }
}

struct SavedCardPaymentMethodData {
    let brand: String
    let issuer: String
    let masked: String
    let expirationDate: String
    let token: String

    init(brand: String, issuer: String, masked: String, expirationDate: String, token: String) {
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
                expirationDate: json["expiration_date"] as! String,
                token: json["token"] as! String
        );
    }

    func toJSON() -> Dictionary<String, String> {
        [
            "brand": brand,
            "issuer": issuer,
            "masked": masked,
            "expiration_date": expirationDate,
            "token": token
        ]
    }

}
