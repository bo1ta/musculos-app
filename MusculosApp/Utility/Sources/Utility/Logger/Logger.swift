//
//  MusculosLogger.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import SwiftyBeaver

public let Logger = ConsoleLogger.shared

public protocol Loggable {
  func logInfo(message: String, properties: [String: Any]?, file: String, function: String, line: Int)
  func logError(_ error: Error, message: String, properties: [String: Any]?, file: String, function: String, line: Int)
  func logWarning(message: String, properties: [String: Any]?, file: String, function: String, line: Int)
}

public struct ConsoleLogger: Loggable, @unchecked Sendable {
  static let shared = ConsoleLogger()

  private let console: ConsoleDestination

  public init() {
    console = ConsoleDestination()
    console.logPrintWay = .logger(subsystem: "NoveltyApp", category: "UI")
  }

  public func logInfo(message: String, properties: [String : Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    console.send(.info, msg: message, thread: Thread.current.threadName, file: file, function: function, line: line, context: properties)
  }

  public func logError(_ error: Error, message: String = "", properties: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    console.send(.error, msg: "\(message) - Error: \(error.localizedDescription)", thread: Thread.current.threadName, file: file, function: function, line: line, context: properties)
  }

  public func logWarning(message: String, properties: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    console.send(.warning, msg: message, thread: Thread.current.threadName, file: file, function: function, line: line, context: properties)
  }
}

extension Thread {
  var threadName: String {
    if isMainThread {
      return "main"
    } else if let threadName = Thread.current.name, !threadName.isEmpty {
      return threadName
    } else {
      return description
    }
  }

  var queueName: String {
    if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
      return queueName
    } else if let operationQueueName = OperationQueue.current?.name, !operationQueueName.isEmpty {
      return operationQueueName
    } else if let dispatchQueueName = OperationQueue.current?.underlyingQueue?.label, !dispatchQueueName.isEmpty {
      return dispatchQueueName
    } else {
      return "n/a"
    }
  }
}
