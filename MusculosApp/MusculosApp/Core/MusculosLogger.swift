//
//  MusculosLogger.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import os.log

final class MusculosLogger {
    enum LogCategory: String {
        case networking
        case coreData
        case ui
    }

    static func log(_ logType: OSLogType, message: String, error: Error? = nil, category: LogCategory) {
        let log = OSLog(subsystem: "com.MusculosApp", category: category.rawValue)
        if let error = error {
            os_log(logType, log: log, "%@ Error: %@", message, error.localizedDescription)
        } else {
            os_log(logType, log: log, "%@", message)
        }
    }
}
