//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

protocol MonriLogger {
    func info(_ message: StaticString, _ args: Any...)
    func trace(_ message: StaticString, _ args: Any...)
    func warn(_ message: StaticString, _ args: Any...)
    func error(_ message: StaticString, _ args: Any...)
    func fatal(_ message: StaticString, _ args: Any...)
}
