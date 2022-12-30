//
//  TransactionParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class TransactionParams {
    private var data: Dictionary<String, String>

    init(data: Dictionary<String, String>) {
        self.data = data
    }

//    public TransactionParams set(@NonNull String key, @Nullable String value) {
//if (value == null) {
//        getData().remove(key);
//} else {
//    getData().put(key, value);
//}
//return this;
//}

    public static func create() -> TransactionParams {
        TransactionParams(data: [:])
    }

    public func set(_ key: String, _ value: String?) -> TransactionParams {
        if (value == nil) {
            data.removeValue(forKey: key)
        } else {
            data[key] = value
        }
        return self
    }

    public func set(customerParams: CustomerParams) -> TransactionParams {
        set("ch_full_name", customerParams.fullName)
                .set("customer_uuid", customerParams.customerUuid)
                .set("ch_address", customerParams.address)
                .set("ch_city", customerParams.city)
                .set("ch_zip", customerParams.zip)
                .set("ch_phone", customerParams.phone)
                .set("ch_country", customerParams.country)
                .set("ch_email", customerParams.email)
    }

    func toJSON() -> Dictionary<String, Any> {
        var metaData: Dictionary<String, Any> = Dictionary();
 
        for metaKey in MetaUtility.META_KEYS {
           let key = "meta.\(metaKey)"
           metaData[metaKey] = data.removeValue(forKey: key)
       }
        
        var rv: Dictionary<String, Any> = data
        rv["meta"] = metaData
        return rv
    }
}
