//
//  ScanDocExtractionResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocExtractionResponse
struct ScanDocExtractionResponse: Codable {
    let transactionID, uploadedAt, productName: String
    let errors, warnings: [String]
    let status: Int
    let method: String
    let infoCode: Int
    let data: DataClass
    let imageData: ImageData
    let analysisTime: String
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "TransactionID"
        case uploadedAt = "UploadedAt"
        case productName = "ProductName"
        case errors = "Errors"
        case warnings = "Warnings"
        case status = "Status"
        case method = "Method"
        case infoCode = "InfoCode"
        case data = "Data"
        case imageData = "ImageData"
        case analysisTime = "AnalysisTime"
    }
    
    static func fromJson(body: [String: Any]) -> ScanDocExtractionResponse? {
        guard
            let transactionID = body["TransactionID"] as? String,
            let uploadedAt = body["UploadedAt"] as? String,
            let productName = body["ProductName"] as? String,
            let errors = body["Errors"] as? [String],
            let warnings = body["Warnings"] as? [String],
            let status = body["Status"] as? Int,
            let method = body["Method"] as? String,
            let infoCode = body["InfoCode"] as? Int,
            let dataDict = body["Data"] as? [String: Any],
            let imageDataDict = body["ImageData"] as? [String: Any],
            let analysisTime = body["AnalysisTime"] as? String,
            let data = DataClass.fromJson(body: dataDict),
            let imageData = ImageData.fromJson(body: imageDataDict)
        else {
            return nil
        }
        
        return ScanDocExtractionResponse(
            transactionID: transactionID,
            uploadedAt: uploadedAt,
            productName: productName,
            errors: errors,
            warnings: warnings,
            status: status,
            method: method,
            infoCode: infoCode,
            data: data,
            imageData: imageData,
            analysisTime: analysisTime
        )
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let cardNumber, expiryDate, holdersName, holdersSurname: DataValue?
    let issuedDate, iban: DataValue?
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "CardNumber"
        case expiryDate = "ExpiryDate"
        case holdersName = "HoldersName"
        case holdersSurname = "HoldersSurname"
        case issuedDate = "IssuedDate"
        case iban = "IBAN"
    }
    
    static func fromJson(body: [String: Any]) -> DataClass? {
        func parseDataValue(_ key: String) -> DataValue? {
            guard let dict = body[key] as? [String: Any] else { return nil }
            return DataValue.fromJson(body: dict)
        }
        
        return DataClass(
            cardNumber: parseDataValue("CardNumber"),
            expiryDate: parseDataValue("ExpiryDate"),
            holdersName: parseDataValue("HoldersName"),
            holdersSurname: parseDataValue("HoldersSurname"),
            issuedDate: parseDataValue("IssuedDate"),
            iban: parseDataValue("IBAN")
        )
    }
}

// MARK: - CardNumber
struct DataValue: Codable {
    let read: Bool
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case read = "Read"
        case value = "Value"
    }
    
    static func fromJson(body: [String: Any]) -> DataValue? {
        guard
            let read = body["Read"] as? Bool,
            let value = body["Value"] as? String
        else {
            return nil
        }
        return DataValue(read: read, value: value)
    }
}

// MARK: - ImageData
struct ImageData: Codable {
    let creditCardImage: String
    
    enum CodingKeys: String, CodingKey {
        case creditCardImage = "CreditCardImage"
    }
    
    static func fromJson(body: [String: Any]) -> ImageData? {
        guard let creditCardImage = body["CreditCardImage"] as? String else {
            return nil
        }
        return ImageData(creditCardImage: creditCardImage)
    }
}
