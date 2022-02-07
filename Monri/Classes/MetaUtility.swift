//
//  MetaUtility.swift
//  Monri
//
//  Created by Adnan Omerovic on 24. 1. 2022..
//

import Foundation

public class MetaUtility {
    private static let PREFERENCE_META_LIBRARY_KEY: String = "com.monri.meta.library"
    private static let LIBRARY: String = "iOS-SDK"
    
    public static let INTEGRATION_TYPE_KEY: String = "integration_type"
    public static let LIBRARY_KEY: String = "library"
    public static let LIBRARY_VERSION_KEY: String = "library_version"

    public static let META_KEYS: Array<String> =  [
        INTEGRATION_TYPE_KEY,
        LIBRARY_KEY,
        LIBRARY_VERSION_KEY
    ]

    private init(){}

    static func getLibrary() -> String{
        let userDefault = UserDefaults.standard
        if userDefault.object(forKey: PREFERENCE_META_LIBRARY_KEY) == nil {
            return LIBRARY
        } else {
            return userDefault.string(forKey: PREFERENCE_META_LIBRARY_KEY)!
        }
    }

}
