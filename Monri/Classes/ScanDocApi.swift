//
//  ScanDocApi.swift
//  Monri
//
//  Created by Karolina Škunca on 28.08.2025..
//

import Foundation
import os.log

internal struct ImageTypes {
    static let BASE_64: String = "base64"
}

public class ScanDocApi {
    
    private let httpClient: ScanDocHttpApiImpl
    private var accessToken: String?
    private var refreshToken: String?
    private var accessTokenExpiration: Date?
    private var refreshTokenExpiration: Date?
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ScanDocApi"))
    }
    
    public init(options: ScanDocApiOptions) {
        self.httpClient = ScanDocHttpApiImpl(options: options, httpClient: MonriFactory().createHttpClient())
    }
    
    public func validateScannedCard(scannedCardImages: [UIImage], validationConfiguration: ValidationConfiguration? = nil, _ callback: @escaping (Result<ScanDocValidationResponse, Error>) -> Void) {
        
        guard let base64Images = ImageProcessingUtil.imagesToCompressedBase64(scannedCardImages) else {
            callback(.failure(ScanDocErrors.invalidImageFormat.asNSError))
            return
        }
        
        let validationRequest = getValidationConfiguration(base64Images: base64Images, validationSettings: validationConfiguration)
        
        getAccessToken() { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.validate(accessToken: accessToken, validationRequest) { result in
                    switch result {
                        
                    case .success(let response):
                        callback(.success(response))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                }
            case .failure(let error):
                callback(.failure(error))
            }
            
        }
        
    }
    
    public func extractDataFromScannedCard(scannedCardImage: UIImage, extractionConfiguration: ExtractionConfiguration? = nil, _ callback: @escaping (Result<ExtractionResponse, Error>) -> Void) {
        
        guard let scannedCardBase64Img = ImageProcessingUtil.imageToCompressedBase64(scannedCardImage) else {
            callback(.failure(ScanDocErrors.invalidImageFormat.asNSError))
            return
        }
        
        let scanDocExtractionRequest = getExtractionConfiguration(base64Img: scannedCardBase64Img, extractionConfiguration: extractionConfiguration)
        
        getAccessToken() { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.extraction(accessToken: accessToken, scanDocExtractionRequest) { result in
                    
                    switch result {
                        
                    case .success(let response):
                        
                        guard response.data?.cardNumber != nil,
                              response.data?.expiryDate != nil else {
                            callback(.failure(ScanDocErrors.unableToReadExtractedData.asNSError))
                            return
                        }
                        
                        callback(.success(response))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                    
                }
            case .failure(let error):
                callback(.failure(error))
            }
            
        }
        
        
    }
    
    private func getAccessToken(_ callback: @escaping (Result<String, Error>) -> Void) {
        
        let now = Date()
        
        if let accessToken = self.accessToken,
           let expiration = self.accessTokenExpiration,
           expiration > now {
            callback(.success(accessToken))
            return
        }
        
        if let refreshToken = self.refreshToken,
           let refreshExpiration = self.refreshTokenExpiration,
           refreshExpiration > now {
            
            httpClient.refreshToken(ScanDocRefreshTokenRequest(refreshToken: refreshToken)) { result in
                switch result {
                case .success(let success):
                    self.accessToken = success.accessToken
                    self.accessTokenExpiration = Date().addingTimeInterval(5 * 60)
                    callback(.success(success.accessToken))
                    
                case .failure(let error):
                    callback(.failure(error))
                }
            }
            return
        }
        
        httpClient.authenticate() { result in
            switch result {
            case .success(let response):
                self.accessToken = response.accessToken
                self.refreshToken = response.refreshToken
                self.accessTokenExpiration = Date().addingTimeInterval(5 * 60)
                self.refreshTokenExpiration = Date().addingTimeInterval(24 * 60 * 60)
                callback(.success(response.accessToken))
                
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    private func getExtractionConfiguration(base64Img: String, extractionConfiguration: ExtractionConfiguration?) -> ScanDocExtractionRequest {
        let scanDocExtractionRequest: ScanDocExtractionRequest
        
        if let extractionConfiguration = extractionConfiguration {
            scanDocExtractionRequest = ScanDocExtractionRequest(dataFields: ExtractionDataFields(image: base64Img,
                                                                                                 imageType: extractionConfiguration.imageConfiguration.imageType,
                                                                                                 imageCropped: extractionConfiguration.imageConfiguration.imageCropped),
                                                                settings: ExtractionSettings(shouldReturnDocumentImage: extractionConfiguration.extractionConfigurationSettings.shouldReturnDocumentImage,
                                                                                             skipDocumentSizeCheck: extractionConfiguration.extractionConfigurationSettings.skipDocumentSizeCheck,
                                                                                             skipImageSizeCheck: extractionConfiguration.extractionConfigurationSettings.skipImageSizeCheck,
                                                                                             canStoreImages: extractionConfiguration.extractionConfigurationSettings.canStoreImages,
                                                                                             dontUseValidation: extractionConfiguration.extractionConfigurationSettings.dontUseValidation),
                                                                acceptTermsAndConditions: self.httpClient.options.acceptTermsAndConditions)
        } else {
            scanDocExtractionRequest = ScanDocExtractionRequest(dataFields: ExtractionDataFields(image: base64Img,
                                                                                                 imageType: ImageTypes.BASE_64,
                                                                                            imageCropped: false),
                                                           settings: ExtractionSettings(shouldReturnDocumentImage: true,
                                                                                        skipDocumentSizeCheck: false,
                                                                                        skipImageSizeCheck: false,
                                                                                        canStoreImages: false,
                                                                                        dontUseValidation: true),
                                                           acceptTermsAndConditions: self.httpClient.options.acceptTermsAndConditions)
        }
        
        return scanDocExtractionRequest
    }
    
    private func getValidationConfiguration(base64Images: [String], validationSettings: ValidationConfiguration?) -> ScanDocValidationRequest {
        
        let validationRequest: ScanDocValidationRequest
        
        if let validationSettings = validationSettings {
            validationRequest = ScanDocValidationRequest(acceptTermsAndConditions: self.httpClient.options.acceptTermsAndConditions,
                                                         dataFields: ValidationDataFields(images: base64Images,
                                                                                          blurValues: validationSettings.blurValues),
                                                         settings: ValidationSettings(skipImageSizeCheck: validationSettings.validationSettings.skipImageSizeCheck))
        } else {
            validationRequest = ScanDocValidationRequest(acceptTermsAndConditions: self.httpClient.options.acceptTermsAndConditions,
                                     dataFields: ValidationDataFields(images: base64Images,
                                                                      blurValues: []),
                                     settings: ValidationSettings(skipImageSizeCheck: false))
        }
        
        return validationRequest
    }

}
