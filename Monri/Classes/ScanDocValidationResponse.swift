//
//  ScanDocValidationResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocValidationResponse
public struct ScanDocValidationResponse: Codable {
    public let transactionID, uploadedAt, productName: String?
    public let errors, warnings: [String]?
    public let status: Int?
    public let method, infoCode: String?
    public let analysisTime: Double?
    public let keypoints: [[Double]]?
    public let validated: Bool?
    public let index: Int?
    public let info: String?
    public let detectedBlurValue: Double?
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "TransactionID"
        case uploadedAt = "UploadedAt"
        case productName = "ProductName"
        case errors = "Errors"
        case warnings = "Warnings"
        case status = "Status"
        case method = "Method"
        case infoCode = "InfoCode"
        case analysisTime = "AnalysisTime"
        case keypoints = "Keypoints"
        case validated = "Validated"
        case index = "Index"
        case info = "Info"
        case detectedBlurValue = "DetectedBlurValue"
    }
    
    
    static func fromJson(body: [String: Any]) -> ScanDocValidationResponse? {
        guard
            let transactionID = body["TransactionID"] as? String,
            let uploadedAt = body["UploadedAt"] as? String,
            let productName = body["ProductName"] as? String,
            let errors = body["Errors"] as? [String],
            let warnings = body["Warnings"] as? [String],
            let status = body["Status"] as? Int,
            let method = body["Method"] as? String,
            let infoCode = body["InfoCode"] as? String,
            let keypoints = body["Keypoints"] as? [[Double]],
            let validated = body["Validated"] as? Bool,
            let index = body["Index"] as? Int,
            let analysisTime = body["AnalysisTime"] as? Double,
            let info = body["Info"] as? String,
            let detectedBlurValue = body["DetectedBlurValue"] as? Double
        else {
            return nil
        }
        
        return ScanDocValidationResponse(
            transactionID: transactionID,
            uploadedAt: uploadedAt,
            productName: productName,
            errors: errors,
            warnings: warnings,
            status: status,
            method: method,
            infoCode: infoCode,
            analysisTime: analysisTime,
            keypoints: keypoints,
            validated: validated,
            index: index,
            info: info,
            detectedBlurValue: detectedBlurValue,
        )
    }
}
