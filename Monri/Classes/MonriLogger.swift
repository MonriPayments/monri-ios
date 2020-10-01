//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

protocol MonriLogger {
    func info(_ message: String)
    func trace(_ message: String)
    func warn(_ message: String)
    func error(_ message: String)
    func fatal(_ message: String)
}


enum MonriLoggerSystems {
    case actionRequiredFlow
}
