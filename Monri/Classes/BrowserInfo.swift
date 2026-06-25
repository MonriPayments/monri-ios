//
//  BrowserInfo.swift
//  monri-ios
//
//  Created by Mateo Dokić on 24.06.2026..
//

import Foundation
import UIKit
import WebKit

public class BrowserInfo {

    private static let colorDepth = 24
    private static let httpAccept = "*/*"

    private let screenWidth: Int
    private let screenHeight: Int
    private let colorDepth: Int
    private let userAgent: String
    private let timeZoneOffset: Int
    private let language: String
    private let javaEnabled: Bool
    private let httpAccept: String
    private let httpUserAgent: String
    private let httpAcceptLanguage: String

    public init(screenWidth: Int,
                screenHeight: Int,
                colorDepth: Int,
                userAgent: String,
                timeZoneOffset: Int,
                language: String,
                javaEnabled: Bool,
                httpAccept: String,
                httpUserAgent: String,
                httpAcceptLanguage: String) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.colorDepth = colorDepth
        self.userAgent = userAgent
        self.timeZoneOffset = timeZoneOffset
        self.language = language
        self.javaEnabled = javaEnabled
        self.httpAccept = httpAccept
        self.httpUserAgent = httpUserAgent
        self.httpAcceptLanguage = httpAcceptLanguage
    }

    public static func create() -> BrowserInfo {
        let screen = UIScreen.main
        let screenWidth = Int(screen.nativeBounds.width)
        let screenHeight = Int(screen.nativeBounds.height)
        let userAgent = defaultUserAgent()
        let language = Locale.current.languageCode ?? ""

        return BrowserInfo(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            colorDepth: colorDepth,
            userAgent: userAgent,
            timeZoneOffset: timeZoneOffset(),
            language: language,
            javaEnabled: false,
            httpAccept: httpAccept,
            httpUserAgent: userAgent,
            httpAcceptLanguage: language
        )
    }

    public func toJSON() -> Dictionary<String, Any> {
        return [
            "screen_width": screenWidth,
            "screen_height": screenHeight,
            "color_depth": colorDepth,
            "user_agent": userAgent,
            "time_zone_offset": timeZoneOffset,
            "language": language,
            "java_enabled": javaEnabled,
            "http_accept": httpAccept,
            "http_user_agent": httpUserAgent,
            "http_accept_language": httpAcceptLanguage
        ]
    }

    private static func timeZoneOffset() -> Int {
        return -TimeZone.current.secondsFromGMT(for: Date()) / 60
    }

    private static func defaultUserAgent() -> String {

        let resolve: () -> String = {
            guard let userAgent = WKWebView().value(forKey: "userAgent") as? String, !userAgent.isEmpty else {
                return ""
            }

            return userAgent
       }

       return Thread.isMainThread ? resolve() : DispatchQueue.main.sync(execute: resolve)
    }
}
 
