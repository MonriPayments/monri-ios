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
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ScanDocApi"))
    }
    
    public init(options: ScanDocApiOptions) {
        self.options = options
        self.httpClient = ScanDocHttpApiImpl(options: options, httpClient: MonriFactory().createHttpClient())
    }
    
    public func validateScannedCard(scannedCardImage: UIImage, _ callback: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let scannedCardBase64Img = getBase64Img(from: scannedCardImage) else {
            callback(.failure(NSError(domain: "Image must be .png or .jpeg format", code: -1001)))
            return
        }
        
        getAccessToken(subKey: options.scanDocSubKey) { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.validate(accessToken: accessToken, ScanDocValidationRequest(acceptTermsAndConditions: true,
                                                                                                     dataFields: ValidationDataFields(images: [scannedCardBase64Img], blurValues: []),
                                                                                                     settings: ValidationSettings(skipImageSizeCheck: true))) { result in
                    switch result {
                        
                    case .success(let response):
                        callback(.success(response.validated))
                    case .failure(let error):
                        callback(.failure(error))
                    }
                }
            case .failure(let error):
                callback(.failure(error))
            }
            
        }
        
    }
    
    public func extractScannedCard(scannedCardImage: UIImage, _ callback: @escaping (Result<Card, Error>) -> Void) {
        
        guard let scannedCardBase64Img = getBase64Img(from: scannedCardImage) else {
            callback(.failure(NSError(domain: "Image must be .png or .jpeg format", code: -1001)))
            return
        }
        
        getAccessToken(subKey: options.scanDocSubKey) { accessTokenResult in
            
            switch accessTokenResult {
                
            case .success(let accessToken):
                self.httpClient.extraction(accessToken: accessToken,
                                      ScanDocExtractionRequest(dataFields: ExtractionDataFields(imageType: scannedCardBase64Img,
                                                                                                imageCropped: false),
                                                               settings: ExtractionSettings(shouldReturnDocumentImage: false,
                                                                                            skipDocumentSizeCheck: true,
                                                                                            skipImageSizeCheck: true,
                                                                                            canStoreImages: false,
                                                                                            dontUseValidation: false),
                                                               acceptTermsAndConditions: true)) { result in
                    
                    switch result {
                        
                    case .success(let response):
                        
                        guard let number = response.data.cardNumber?.value,
                              let expiry = response.data.expiryDate?.value else {
                            
                            callback(.failure(NSError(domain: "Data couldn't be read", code: -1000)))
                            return
                        }
                        
                        let expMonth = expiry.split(separator: "/").first ?? ""
                        let expYear = expiry.split(separator: "/").last ?? ""
                        
                        let card = Card(number: number,
                                        cvc: "",
                                        expMonth: Int(expMonth) ?? 0,
                                        expYear: Int(expYear) ?? 0)
                        
                        callback(.success(card))
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
        
        if let imageData = image.pngData() { // or .jpegData(compressionQuality: 1.0)
            let base64String = imageData.base64EncodedString()
            print(base64String)
            return base64String
        }
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
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
