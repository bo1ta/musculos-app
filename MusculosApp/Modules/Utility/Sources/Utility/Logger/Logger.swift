//
//  Logger.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import SwiftyBeaver

public let Logger = ConsoleLogger.shared // swiftlint:disable:this identifier_name

// MARK: - ConsoleLogger

public struct ConsoleLogger: Loggable, @unchecked Sendable {
  static let shared = ConsoleLogger()

  private let console: ConsoleDestination

  private var isRunningTest: Bool = NSClassFromString("XCTest") != nil

  public init() {
    console = ConsoleDestination()
    console.logPrintWay = .logger(subsystem: "MusculosApp", category: "UI")
  }

  public func info(
    message: String,
    properties: [String: Any]? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line)
  {
    guard !isRunningTest else {
      return
    }
    console.send(
      .info,
      msg: message,
      thread: Thread.current.threadName,
      file: file,
      function: function,
      line: line,
      context: properties)
  }

  public func error(
    _ error: Error,
    message: String = "",
    properties: [String: Any]? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line)
  {
    console.send(
      .error,
      msg: "\(message) - Error: \(error.localizedDescription)",
      thread: Thread.current.threadName,
      file: file,
      function: function,
      line: line,
      context: properties)
  }

  public func warning(
    message: String,
    properties: [String: Any]? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line)
  {
    console.send(
      .warning,
      msg: message,
      thread: Thread.current.threadName,
      file: file,
      function: function,
      line: line,
      context: properties)
  }
}

extension Thread {
  var threadName: String {
    if isMainThread {
      "main"
    } else if let threadName = Thread.current.name, !threadName.isEmpty {
      threadName
    } else {
      description
    }
  }

  var queueName: String {
    if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
      queueName
    } else if let operationQueueName = OperationQueue.current?.name, !operationQueueName.isEmpty {
      operationQueueName
    } else if let dispatchQueueName = OperationQueue.current?.underlyingQueue?.label, !dispatchQueueName.isEmpty {
      dispatchQueueName
    } else {
      "n/a"
    }
  }
}
