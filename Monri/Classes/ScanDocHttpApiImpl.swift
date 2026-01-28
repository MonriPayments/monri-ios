//
//  ScanDocHttpApiImpl.swift
//  Monri
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation
import os.log

internal struct ScanDocApiConstants {
    static let SCAN_DOC_BASE_URL: String = "https://api.scandoc.ai/ks/"
    static let AUTHENTICATE_ENDPOINT: String = "authenticate/"
    static let AUTHENTICATE_REFRESH_ENDPOINT: String = "authenticate/refresh"
    static let VALIDATION_ENDPOINT: String = "validation/"
    static let EXTRACTION_ENDPOINT: String = "extraction/"
    static let CONTENT_TYPE_HEADER_KEY: String = "content-type"
    static let ACCEPT_HEADER_KEY: String = "accept"
    static let JSON_HEADER_VALUE: String = "application/json"
    static let AUTHORIZATION_HEADER_KEY: String = "Authorization"
}

class ScanDocHttpApiImpl: ScanDocHttpApi {
    
    let MONRI_LOG_CONSTANT: String = "Monri ScanDoc"
    
    let options: ScanDocApiOptions
    private let httpClient: MonriHttpClient
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ScanDocHttpApiImpl"))
    }
    
    init(options: ScanDocApiOptions, httpClient: MonriHttpClient) {
        self.options = options
        self.httpClient = httpClient
    }
    
    func authenticate(_ callback: @escaping (Result<AuthenticateResponse, any Error>) -> Void) {
        
        let authParams = ScanDocAuthenticateRequest(userKey: options.scanDocUserKey,
                                                    subClient: options.scanDocSubKey)
        
        httpClient.jsonPost(url: ScanDocApiConstants.SCAN_DOC_BASE_URL + ScanDocApiConstants.AUTHENTICATE_ENDPOINT,
                            body: authParams.toJson(),
                            headers: [
                                ScanDocApiConstants.ACCEPT_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.CONTENT_TYPE_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: self.MONRI_LOG_CONSTANT, code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let authenticateResponse = AuthenticateResponse.fromJson(body: body) else {
                                        callback(.failure(ScanDocErrors.unableToMapResponse.asNSError))
                                        return
                                    }
                                    
                                    callback(.success(authenticateResponse))
                                    return
                                case .error(let error):
                                    callback(.failure(error))
                                    return
                                }
                            }
    }
    
    func refreshToken(_ refreshToken: ScanDocRefreshTokenRequest, _ callback: @escaping (Result<ScanDocRefreshTokenResponse, any Error>) -> Void) {
        
        httpClient.jsonPost(url: ScanDocApiConstants.SCAN_DOC_BASE_URL + ScanDocApiConstants.AUTHENTICATE_REFRESH_ENDPOINT,
                            body: refreshToken.toJson(),
                            headers: [
                                ScanDocApiConstants.ACCEPT_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.CONTENT_TYPE_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: self.MONRI_LOG_CONSTANT, code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let refreshResponse = ScanDocRefreshTokenResponse.fromJson(body: body) else {
                                        callback(.failure(ScanDocErrors.unableToMapResponse.asNSError))
                                        return
                                    }
                                    
                                    callback(.success(refreshResponse))
                                    return
                                case .error(let error):
                                    callback(.failure(error))
                                    return
                                }
                            }
    }
    
    func validate(accessToken: String, _ validationParams: ScanDocValidationRequest, _ callback: @escaping (Result<ScanDocValidationResponse, any Error>) -> Void) {
        
        httpClient.jsonPost(url: options.scanDocApiBaseUrl + ScanDocApiConstants.VALIDATION_ENDPOINT,
                            body: validationParams.toJson(),
                            headers: [
                                ScanDocApiConstants.ACCEPT_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.CONTENT_TYPE_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.AUTHORIZATION_HEADER_KEY: accessToken
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: self.MONRI_LOG_CONSTANT, code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let response = ScanDocValidationResponse.fromJson(body: body) else {
                                        callback(.failure(ScanDocErrors.unableToMapResponse.asNSError))
                                        return
                                    }
                                    
                                    callback(.success(response))
                                    return
                                case .error(let error):
                                    callback(.failure(error))
                                    return
                                }
                            }
    }
    
    func extraction(accessToken: String, _ extractionParams: ScanDocExtractionRequest, _ callback: @escaping (Result<ExtractionResponse, any Error>) -> Void) {
        
        httpClient.jsonPost(url: options.scanDocApiBaseUrl + ScanDocApiConstants.EXTRACTION_ENDPOINT,
                            body: extractionParams.toJson(),
                            headers: [
                                ScanDocApiConstants.ACCEPT_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.CONTENT_TYPE_HEADER_KEY: ScanDocApiConstants.JSON_HEADER_VALUE,
                                ScanDocApiConstants.AUTHORIZATION_HEADER_KEY: accessToken
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: self.MONRI_LOG_CONSTANT, code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let response = ExtractionResponse.fromJson(body: body) else {
                                        callback(.failure(ScanDocErrors.unableToMapResponse.asNSError))
                                        return
                                    }
                                    
                                    callback(.success(response))
                                    return
                                case .error(let error):
                                    callback(.failure(error))
                                    return
                                }
                            }
    }
    
    
}
