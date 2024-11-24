//
//  NetworkMonitor.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Network
import Foundation
import Combine

public protocol NetworkMonitorProtocol {
  var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> { get }
  var isConnected: Bool { get }
  func startMonitoring()
  func stopMonitoring()
}

public class NetworkMonitor: NetworkMonitorProtocol, @unchecked Sendable {
  private let monitor = NWPathMonitor()
  private let connectionStatusSubject = CurrentValueSubject<NWPath.Status, Never>(.requiresConnection)

  public var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> {
    return connectionStatusSubject
      .removeDuplicates()
      .eraseToAnyPublisher()
  }

  public var isConnected: Bool {
    return connectionStatusSubject.value == .satisfied
  }

  public init() {
    startMonitoring()
  }

  public func startMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.connectionStatusSubject.send(path.status)
    }
    monitor.start(queue: DispatchQueue.main)
  }

  public func stopMonitoring() {
    monitor.cancel()
  }
}
