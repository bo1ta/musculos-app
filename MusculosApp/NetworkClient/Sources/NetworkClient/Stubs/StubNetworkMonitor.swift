//
//  StubNetworkMonitor.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Network

public struct StubNetworkMonitor: NetworkMonitorProtocol {
  private let connectionStatusSubject: CurrentValueSubject<NWPath.Status, Never>

  public var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> {
    connectionStatusSubject.eraseToAnyPublisher()
  }

  public var isConnected: Bool

  public init(isConnected: Bool) {
    self.isConnected = isConnected
    self.connectionStatusSubject = .init(isConnected ? .satisfied : .unsatisfied)
  }

  public func startMonitoring() { }

  public func stopMonitoring() { }
}
