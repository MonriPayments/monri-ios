//
//  ScanDocValidationResponse.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//


import Foundation

// MARK: - ScanDocValidationResponse
struct ScanDocValidationResponse: Codable {
    let transactionID, uploadedAt, productName: String
    let errors, warnings: [String]
    let status: Int
    let method: String
    let infoCode: Int
    let keypoints: [[Double]]
    let detectedBlurValue: Double
    let validated: Bool
    let index: Int
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
        case keypoints = "Keypoints"
        case detectedBlurValue = "DetectedBlurValue"
        case validated = "Validated"
        case index = "Index"
        case analysisTime = "AnalysisTime"
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
                let infoCode = body["InfoCode"] as? Int,
                let keypoints = body["Keypoints"] as? [[Double]],
                let detectedBlurValue = body["DetectedBlurValue"] as? Double,
                let validated = body["Validated"] as? Bool,
                let index = body["Index"] as? Int,
                let analysisTime = body["AnalysisTime"] as? String
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
                keypoints: keypoints,
                detectedBlurValue: detectedBlurValue,
                validated: validated,
                index: index,
                analysisTime: analysisTime
            )
        }
}
