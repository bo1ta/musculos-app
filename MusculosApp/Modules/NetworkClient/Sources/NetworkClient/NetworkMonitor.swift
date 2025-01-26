//
//  NetworkMonitor.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Combine
import Foundation
import Network
import Utility

// MARK: - NetworkMonitorProtocol

public protocol NetworkMonitorProtocol: Sendable {
  var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> { get }
  var isConnected: Bool { get }

  func startMonitoring()
  func stopMonitoring()
}

// MARK: - NetworkMonitor

public class NetworkMonitor: NetworkMonitorProtocol, @unchecked Sendable {
  private let queue = DispatchQueue(label: "com.NetworkClient.NetworkMonitorQueue")
  private let monitor = NWPathMonitor()
  private let connectionStatusSubject = CurrentValueSubject<NWPath.Status, Never>(.requiresConnection)

  public var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> {
    connectionStatusSubject
      .removeDuplicates()
      .eraseToAnyPublisher()
  }

  public var isConnected: Bool {
    connectionStatusSubject.value == .satisfied
  }

  public init() {
    startMonitoring()
  }

  public func startMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.connectionStatusSubject.send(path.status)
    }
    monitor.start(queue: queue)
  }

  public func stopMonitoring() {
    monitor.cancel()
  }
}
