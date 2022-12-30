//
// Created by Jasmin Suljic on 03/09/2020.
//

import Foundation
import Alamofire

class AlamofireMonriHttpClient: MonriHttpClient {

    func jsonPost(url: String, body: [String: Any], headers: [String: String], _ callback: @escaping (MonriHttpClientResponse) -> Void) {
        Alamofire.request(url,
                        method: .post,
                        parameters: body,
                        encoding: JSONEncoding.default,
                        headers: headers
                )
                .responseJSON { dataResponse in
                    self.handleResponse(dataResponse, callback)
                }
    }

    func jsonGet(url: String, headers: [String: String], _ callback: @escaping (MonriHttpClientResponse) -> Void) {
        Alamofire.request(url,
                        method: .get,
                        encoding: JSONEncoding.default,
                        headers: headers
                )
                .responseJSON { dataResponse in
                    self.handleResponse(dataResponse, callback)
                }
    }

    func jsonDelete(url: String, headers: [String: String], _ callback: @escaping (MonriHttpClientResponse) -> Void) {
        Alamofire.request(url,
                        method: .delete,
                        encoding: JSONEncoding.default,
                        headers: headers
                )
                .responseJSON { dataResponse in
                    self.handleResponse(dataResponse, callback)
                }
    }

    func handleResponse(_ dataResponse: DataResponse<Any>, _ callback: @escaping (MonriHttpClientResponse) -> Void) {
        do {
            let statusCode = dataResponse.response!.statusCode

            guard let data = dataResponse.data else {
                callback(.error(.responseDataMissing))
                return
            }

            let headers = dataResponse.response!.allHeaderFields

            if (statusCode >= 200 && statusCode < 300) {

                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    callback(.error(.jsonParsingError("Converting response = \(data) to JSON failed!")))
                    return
                }

                callback(.success(body: json, statusCode: statusCode, headers: dataResponse.response!.allHeaderFields))
            } else {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    callback(.error(.jsonParsingError("Converting response = \(data) to JSON failed!")))
                    return
                }
                callback(.failure(body: json, statusCode: statusCode, headers: headers))
            }
        } catch {
            callback(.error(.responseParsingError(error)))
        }
    }
}
