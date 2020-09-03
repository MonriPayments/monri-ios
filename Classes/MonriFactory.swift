//
// Created by Jasmin Suljic on 03/09/2020.
//

import Foundation

public class MonriFactory {
    public init() {

    }

    public func createPaymentApi(options: MonriApiOptions, httpClient: MonriHttpClient? = nil) -> MonriPaymentApi {
        return MonriPaymentApiImpl(options: options, httpClient: httpClient ?? createHttpClient())
    }

    public func createHttpClient() -> MonriHttpClient {
        return AlamofireMonriHttpClient()
    }
}
