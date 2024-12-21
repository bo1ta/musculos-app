//
//  Loggable.swift
//  Utility
//
//  Created by Solomon Alexandru on 19.12.2024.
//

public protocol Loggable {
  func info(message: String, properties: [String: Any]?, file: String, function: String, line: Int)
  func error(_ error: Error, message: String, properties: [String: Any]?, file: String, function: String, line: Int)
  func warning(message: String, properties: [String: Any]?, file: String, function: String, line: Int)
}
