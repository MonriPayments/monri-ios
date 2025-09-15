//
//  ScanDocHttpApiImpl.swift
//  Monri
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation
import os.log

class ScanDocHttpApiImpl: ScanDocHttpApi {
    
    let options: ScanDocApiOptions
    let apiUrl: String
    let scanDocUserKey: String
    private let httpClient: MonriHttpClient
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ScanDocHttpApiImpl"))
    }
    
    init(options: ScanDocApiOptions, httpClient: MonriHttpClient) {
        self.options = options
        self.scanDocUserKey = options.scanDocUserKey
        self.apiUrl = options.scanDocApiUrl
        self.httpClient = httpClient
    }
    
    func authenticate(_ subClient: String, _ callback: @escaping (Result<ScanDocAuthenticateResponse, any Error>) -> Void) {
        
        let authParams = ScanDocAuthenticateRequest(userKey: scanDocUserKey,
                                                    subClient: subClient)
        
        httpClient.jsonPost(url: "\(apiUrl)/authenticate/",
                            body: authParams.toJson(),
                            headers: [
                                "accept": "application/json",
                                "content-type": "application/json"
                            ]) {
            switch ($0) {
            case .failure(let body, let statusCode, _):
                callback(.failure(NSError(domain: "Monri ScanDoc", code: statusCode, userInfo: body)))
                return
            case .success(let body, _, _):
                
                guard let authenticateResponse = ScanDocAuthenticateResponse.fromJson(body: body) else {
                    callback(.failure(NSError(domain: "Monri ScanDoc: Unable to map response", code: -10002)))
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
        
        httpClient.jsonPost(url: "\(apiUrl)/authenticate/refresh",
                            body: refreshToken.toJson(),
                            headers: [
                                "accept": "application/json",
                                "content-type": "application/json"
                            ]) {
            switch ($0) {
            case .failure(let body, let statusCode, _):
                callback(.failure(NSError(domain: "Monri ScanDoc", code: statusCode, userInfo: body)))
                return
            case .success(let body, _, _):
                
                guard let refreshResponse = ScanDocRefreshTokenResponse.fromJson(body: body) else {
                    //TODO change errors
                    callback(.failure(NSError(domain: "Monri ScanDoc: Unable to map response", code: -10002)))
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
        
        httpClient.jsonPost(url: "\(apiUrl)/validation/",
                            body: validationParams.toJson(),
                            headers: [
                                "accept": "application/json",
                                "content-type": "application/json",
                                "Authorization": accessToken
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: "Monri ScanDoc", code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let response = ScanDocValidationResponse.fromJson(body: body) else {
                                        //TODO change errors
                                        callback(.failure(NSError(domain: "Monri ScanDoc: Unable to map response", code: -10002)))
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
    
    func extraction(accessToken: String, _ extractionParams: ScanDocExtractionRequest, _ callback: @escaping (Result<ScanDocExtractionResponse, any Error>) -> Void) {
        
        httpClient.jsonPost(url: "\(apiUrl)/extraction/",
                            body: extractionParams.toJson(),
                            headers: [
                                "accept": "application/json",
                                "content-type": "application/json",
                                "Authorization": accessToken
                            ]) {
                                switch ($0) {
                                case .failure(let body, let statusCode, _):
                                    callback(.failure(NSError(domain: "Monri ScanDoc", code: statusCode, userInfo: body)))
                                    return
                                case .success(let body, _, _):
                                    
                                    guard let response = ScanDocExtractionResponse.fromJson(body: body) else {
                                        //TODO change errors
                                        callback(.failure(NSError(domain: "Monri ScanDoc: Unable to map response", code: -10002)))
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
