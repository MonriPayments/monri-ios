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

    func info(_ message: StaticString, _ args: Any...) {
        os_log(message, log: log, type: .info, args)
    }

    func error(_ message: StaticString, _ args: Any...) {
        os_log(message, log: log, type: .error, args)
    }

    func trace(_ message: StaticString, _ args: Any...) {
        os_log(message, log: log, type: .debug, args)
    }

    func warn(_ message: StaticString, _ args: Any...) {
        os_log(message, log: log, type: .error, args)
    }

    func fatal(_ message: StaticString, _ args: Any...) {
        os_log(message, log: log, type: .fault, args)
    }
}

extension OSLog {
    static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")

}
