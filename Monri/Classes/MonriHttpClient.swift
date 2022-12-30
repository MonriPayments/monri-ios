//
// Created by Jasmin Suljic on 03/09/2020.
//

import Foundation

public protocol MonriHttpClient {
    func jsonPost(url: String, body: [String: Any], headers: [String : String], _ callback: @escaping (MonriHttpClientResponse) -> Void)
    func jsonGet(url: String, headers: [String : String], _ callback: @escaping (MonriHttpClientResponse) -> Void)
    func jsonDelete(url: String, headers: [String : String], _ callback: @escaping (MonriHttpClientResponse) -> Void)
}

public enum MonriHttpClientResponse {
    // 200 - 300 status codes
    case success(body: [String: Any], statusCode: Int, headers: [AnyHashable : Any])
    // Non 200 - 300 status codes
    case failure(body: [String: Any], statusCode: Int, headers: [AnyHashable : Any])
    // something went really wrong, parsing issue, ssl issue etc
    case error(MonriHttpClientError)
}

public enum MonriHttpClientError: Error {
    case responseDataMissing
    case jsonParsingError(String)
    case responseParsingError(Error)
}
