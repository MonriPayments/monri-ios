//
//  ScanDocHttpApi.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//

internal protocol ScanDocHttpApi {
    func authenticate(_ callback: @escaping (Result<ScanDocAuthenticateResponse, Error>) -> Void)
    func refreshToken(_ refreshToken: ScanDocRefreshTokenRequest, _ callback: @escaping (Result<ScanDocRefreshTokenResponse, Error>) -> Void)
    func validate(accessToken: String, _ validationParams: ScanDocValidationRequest, _ callback: @escaping (Result<ScanDocValidationResponse, Error>) -> Void)
    func extraction(accessToken: String, _ extractionParams: ScanDocExtractionRequest, _ callback: @escaping (Result<ScanDocExtractionResponse, Error>) -> Void)
}
