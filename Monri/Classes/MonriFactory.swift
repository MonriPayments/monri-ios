//
// Created by Jasmin Suljic on 03/09/2020.
//

import Foundation

public class MonriFactory {
    public init() {

    }

    public func createHttpApi(options: MonriApiOptions, httpClient: MonriHttpClient? = nil) -> MonriHttpApi {
        return MonriHttpApiImpl(options: options, httpClient: httpClient ?? createHttpClient())
    }

    public func createHttpClient() -> MonriHttpClient {
        return AlamofireMonriHttpClient()
    }
}
