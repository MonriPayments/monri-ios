//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import os.log

class MonriLoggerImpl: MonriLogger {

    let log: OSLog

    init(log: OSLog) {
        self.log = log
    }

    func info(_ message: String) {
        os_log("%s", log: log, type: .info, message)
    }

    func error(_ message: String) {
        os_log("%s", log: log, type: .error, message)
    }

    func trace(_ message: String) {
        os_log("%s", log: log, type: .debug, message)
    }

    func warn(_ message: String) {
        os_log("%s", log: log, type: .error, message)
    }

    func fatal(_ message: String) {
        os_log("%s", log: log, type: .fault, message)
    }
}

