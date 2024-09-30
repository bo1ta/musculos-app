//
//  TaskManager.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Foundation

public protocol TaskManagerProtocol {
  func addTask(_ task: Task<Void, Never>, forFunction function: String)
  func cancelTask(forFunction function: String)
  func getTask(forFunction function: String) -> Task<Void, Never>?
  func cancelAllTasks()
  func getAllTasks() -> [Task<Void, Never>]
}

public extension TaskManagerProtocol {
  func addTask(_ task: Task<Void, Never>, forFunction function: String = #function) {
    addTask(task, forFunction: function)
  }

  func cancelTask(forFunction function: String = #function) {
    cancelTask(forFunction: function)
  }

  func getTask(forFunction function: String = #function) -> Task<Void, Never>? {
    getTask(forFunction: function)
  }
}

public class TaskManager: TaskManagerProtocol {
  private var tasks: [String: Task<Void, Never>] = [:]

  public init() {}

  public func addTask(_ task: Task<Void, Never>, forFunction function: String) {
    cancelTask(forFunction: function)
    tasks[function] = task
  }

  public func cancelTask(forFunction function: String) {
    tasks[function]?.cancel()
    tasks[function] = nil
  }

  public func getTask(forFunction function: String) -> Task<Void, Never>? {
    return tasks[function]
  }

  public func cancelAllTasks() {
    tasks.values.forEach { $0.cancel() }
    tasks.removeAll()
  }

  public func getAllTasks() -> [Task<Void, Never>] {
    return Array(tasks.values)
  }
}

