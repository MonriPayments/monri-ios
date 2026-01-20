//
//  ScanDocApi.swift
//  Monri
//
//  Created by Karolina Škunca on 28.08.2025..
//

import Foundation
import os.log

public class ScanDocApi {
    
    let options: ScanDocApiOptions
    private let httpClient: ScanDocHttpApiImpl
    private var accessToken: String?
    private var refreshToken: String?
    private var accessTokenExpiration: Date?
    private var refreshTokenExpiration: Date?
    private let IMAGE_TYPE: String = "base64"
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ScanDocApi"))
    }
    
    public init(options: ScanDocApiOptions) {
        self.options = options
        self.httpClient = ScanDocHttpApiImpl(options: options, httpClient: MonriFactory().createHttpClient())
    }
    
    public func validateScannedCard(scannedCardImage: UIImage, _ callback: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let scannedCardBase64Img = getBase64Img(from: scannedCardImage) else {
            callback(.failure(ScanDocErrors.invalidImageFormat.asNSError))
            return
        }
        
        getAccessToken(subKey: options.scanDocSubKey) { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.validate(accessToken: accessToken, ScanDocValidationRequest(acceptTermsAndConditions: true,
                                                                                                     dataFields: ValidationDataFields(images: [scannedCardBase64Img], blurValues: []),
                                                                                                     settings: ValidationSettings(skipImageSizeCheck: false))) { result in
                    switch result {
                        
                    case .success(let response):
                        callback(.success(response.validated ?? false))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                }
            case .failure(let error):
                callback(.failure(error))
            }
            
        }
        
    }
    
    public func extractScannedCard(scannedCardImage: UIImage, _ callback: @escaping (Result<ScanDocExtractionResponse, Error>) -> Void) {
        
        guard let scannedCardBase64Img = getBase64Img(from: scannedCardImage) else {
            callback(.failure(ScanDocErrors.invalidImageFormat.asNSError))
            return
        }
        
        getAccessToken(subKey: options.scanDocSubKey) { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.extraction(accessToken: accessToken,
                                           ScanDocExtractionRequest(dataFields: ExtractionDataFields(image: scannedCardBase64Img,
                                                                                                     imageType: self.IMAGE_TYPE,
                                                                                                imageCropped: false),
                                                               settings: ExtractionSettings(shouldReturnDocumentImage: true,
                                                                                            skipDocumentSizeCheck: false,
                                                                                            skipImageSizeCheck: false,
                                                                                            canStoreImages: false,
                                                                                            dontUseValidation: true),
                                                               acceptTermsAndConditions: true)) { result in
                    
                    switch result {
                        
                    case .success(let response):
                        
                        guard response.data?.cardNumber?.value != nil,
                              response.data?.expiryDate?.value != nil else {
                            
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
    
    private func getBase64Img(from image: UIImage) -> String? {
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let base64String = imageData.base64EncodedString()
            return base64String
        }
        
        return nil
    }
    
    
    private func getAccessToken(subKey: String, _ callback: @escaping (Result<String, Error>) -> Void) {
        
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
        
        httpClient.authenticate(subKey) { result in
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

}
