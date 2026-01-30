//
//  ExtractionResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocExtractionResponse
public struct ExtractionResponse: Codable {
    public let transactionID, uploadedAt, productName: String?
    public let errors, warnings: [String]?
    public let status: Int?
    public let method, infoCode: String?
    public let analysisTime: Double?
    public let os, browser, device: String?
    public let data: ScanDocCardData?
    public let imageData: ImageData?
    
    public enum CodingKeys: String, CodingKey {
        case transactionID = "TransactionID"
        case uploadedAt = "UploadedAt"
        case productName = "ProductName"
        case errors = "Errors"
        case warnings = "Warnings"
        case status = "Status"
        case method = "Method"
        case infoCode = "InfoCode"
        case analysisTime = "AnalysisTime"
        case os = "OS"
        case browser = "Browser"
        case device = "Device"
        case data = "Data"
        case imageData = "ImageData"
    }
    
    public static func fromJson(body: [String: Any]) -> ExtractionResponse? {
        guard
            let transactionID = body["TransactionID"] as? String,
            let uploadedAt = body["UploadedAt"] as? String,
            let productName = body["ProductName"] as? String,
            let errors = body["Errors"] as? [String],
            let warnings = body["Warnings"] as? [String],
            let status = body["Status"] as? Int,
            let method = body["Method"] as? String,
            let infoCode = body["InfoCode"] as? String,
            let dataDict = body["Data"] as? [String: Any],
            let imageDataDict = body["ImageData"] as? [String: Any],
            let analysisTime = body["AnalysisTime"] as? Double,
            let data = ScanDocCardData.fromJson(body: dataDict),
            let imageData = ImageData.fromJson(body: imageDataDict)
        else {
            return nil
        }
        
        let os = body["OS"] as? String
        let browser = body["Browser"] as? String
        let device = body["Device"] as? String
        
        return ExtractionResponse(transactionID: transactionID,
                                         uploadedAt: uploadedAt,
                                         productName: productName,
                                         errors: errors,
                                         warnings: warnings,
                                         status: status,
                                         method: method,
                                         infoCode: infoCode,
                                         analysisTime: analysisTime,
                                         os: os,
                                         browser: browser,
                                         device: device,
                                         data: data,
                                         imageData: imageData)
    }
}

// MARK: - ScanDocCardData
public struct ScanDocCardData: Codable {
    public let holdersName, luhnCheck, cardNumber, expiryDate: String?
    public let extractedTexts, iban, issuedDate: String?
    
    public enum CodingKeys: String, CodingKey {
        case holdersName = "HoldersName"
        case luhnCheck = "LuhnCheck"
        case cardNumber = "CardNumber"
        case expiryDate = "ExpiryDate"
        case extractedTexts = "ExtractedTexts"
        case iban = "IBAN"
        case issuedDate = "IssuedDate"
    }
    
    public static func fromJson(body: [String: Any]) -> ScanDocCardData? {
        func parseDataValue(_ key: String) -> String? {
            guard let dict = body[key] as? [String: Any], let readValues = CardNumber.fromJson(body: dict) else { return nil }
            return readValues.value
        }
        
        return ScanDocCardData(holdersName: parseDataValue("HoldersName"),
                         luhnCheck: parseDataValue("LuhnCheck"),
                         cardNumber: parseDataValue("CardNumber"),
                         expiryDate: parseDataValue("ExpiryDate"),
                         extractedTexts: parseDataValue("ExtractedTexts"),
                         iban: parseDataValue("IBAN"),
                         issuedDate: parseDataValue("IssuedDate"))
    }
}



// MARK: - CardNumber
public struct CardNumber: Codable {
    public let read: Bool
    public let value: String
    
    public enum CodingKeys: String, CodingKey {
        case read = "Read"
        case value = "Value"
    }
    
    public static func fromJson(body: [String: Any]) -> CardNumber? {
        guard
            let read = body["Read"] as? Bool,
            let value = body["Value"] as? String
        else {
            return nil
        }
        return CardNumber(read: read, value: value)
    }
}

// MARK: - ImageData
public struct ImageData: Codable {
    public let creditCardImage: String
    
    public enum CodingKeys: String, CodingKey {
        case creditCardImage = "CreditCardImage"
    }
    
    public static func fromJson(body: [String: Any]) -> ImageData? {
        guard let creditCardImage = body["CreditCardImage"] as? String else {
            return nil
        }
        return ImageData(creditCardImage: creditCardImage)
    }
}
