//
//  StubNetworkMonitor.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Network

public class StubNetworkMonitor: NetworkMonitorProtocol, @unchecked Sendable {
  public lazy var connectionStatusStream: AsyncStream<NWPath.Status> = AsyncStream { continuation in
    self.continuation = continuation
  }

  private var continuation: AsyncStream<NWPath.Status>.Continuation?

  private let connectionStatusSubject: CurrentValueSubject<NWPath.Status, Never>

  public var connectionStatusPublisher: AnyPublisher<NWPath.Status, Never> {
    connectionStatusSubject.eraseToAnyPublisher()
  }

  public var isConnected: Bool

  public init(isConnected: Bool) {
    self.isConnected = isConnected

    let connectionStatus: NWPath.Status = isConnected ? .satisfied : .unsatisfied
    self.connectionStatusSubject = .init(connectionStatus)
    continuation?.yield(connectionStatus)
  }

  public func startMonitoring() { }

  public func stopMonitoring() { }
}
