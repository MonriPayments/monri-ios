//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

protocol MonriLogger {
    func info(message: StaticString, _ args: Any...)
    func trace(message: StaticString, _ args: Any...)
    func warn(message: StaticString, _ args: Any...)
    func error(message: StaticString, _ args: Any...)
    func fatal(message: StaticString, _ args: Any...)
}
