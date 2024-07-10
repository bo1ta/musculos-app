//
//  MusculosLogger.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import os.log

public final class MusculosLogger {
  public enum LogCategory: String {
    case networking, coreData, ui, healthKit, recommendationEngine
  }
  
  public enum AccessLevel: String {
    case `public`, `private`
  }
  
  public static func logInfo(message: String,
                      category: LogCategory,
                      accessLevel: AccessLevel = .private,
                      properties: [String: Any] = [:]) {
    let logMessage = constructLogMessage(message: message, category: category, properties: properties)
    log(.info, category: category, message: logMessage, accessLevel: accessLevel)
  }
  
  public static func logError(_ error: Error,
                       message: String,
                       category: LogCategory,
                       accessLevel: AccessLevel = .private,
                       properties: [String: Any] = [:]) {
    let logMessage = constructLogMessage(error: error, message: message, category: category, properties: properties)
    log(.error, category: category, message: logMessage, accessLevel: accessLevel)
  }
}

// MARK: - Private helpers

extension MusculosLogger {
  private static func constructLogMessage(error: Error? = nil,
                                          message: String,
                                          category: LogCategory,
                                          properties: [String: Any]) -> String {
    var logMessage: String
    if let error = error {
      logMessage = "🟥 \(category.rawValue.uppercased()) ERROR: \(error.localizedDescription) \n INFO: \(message)"
    } else {
      logMessage = "ℹ️ \(category.rawValue.uppercased()): \(message)"
    }
    
    if !properties.isEmpty {
      let propertiesString = properties.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
      logMessage.append(", PROPERTIES: \(propertiesString)")
    }
    
    return logMessage
  }
  
  private static func createOSLog(category: LogCategory) -> OSLog {
    return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: category.rawValue)
  }
  
  private static func log(_ type: OSLogType, category: LogCategory, message: String, accessLevel: AccessLevel) {
    // disable logs during unit tests
    guard NSClassFromString("XCTestCase") == nil else { return }
    
    #if DEBUG
      switch accessLevel {
      case .private:
        os_log("%{private}@", log: createOSLog(category: category), type: type, message)
      case .public:
        os_log("%{public}@", log: createOSLog(category: category), type: type, message)
      }
    #endif
    }
}
