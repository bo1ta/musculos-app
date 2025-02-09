//
//  OfflineRequestManager.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Combine
import Factory
import Foundation
import Network
import Utility

actor OfflineRequestManager {
  @Injected(\NetworkContainer.networkMonitor) private var networkMonitor: NetworkMonitorProtocol

  private var pendingRequests: [APIRequest] = []

  private var isInternetAvailable = false
  private var retryTask: Task<Void, Never>?

  init() {
    Task {
      for await connectionStatus in await networkMonitor.connectionStatusPublisher.values {
        await handleConnectionChange(connectionStatus)
      }
    }
  }

  private func handleConnectionChange(_ connectionStatus: NWPath.Status) async {
    let wasOffline = !isInternetAvailable
    isInternetAvailable = connectionStatus == .satisfied

    guard isInternetAvailable, wasOffline else {
      return
    }

    if let retryTask {
      await retryTask.result
    }

    retryTask = Task {
      await retryPendingRequests()
    }
  }

  private func retryPendingRequests() async {
    let requestsToRetry = pendingRequests
    pendingRequests.removeAll()

    for request in requestsToRetry {
      do {
        try await dispatch(request)
        Logger.info(message: "Retry succeeded after recovering network connectivity")
      } catch {
        if isConnectionError(error) {
          addToPendingRequests(request)
        }
      }
    }
  }

  private func dispatch(_ request: APIRequest) async throws {
    guard let request = request.asURLRequest() else {
      throw MusculosError.networkError(.badRequest)
    }

    _ = try await URLSession.shared.data(for: request)
  }

  func addToPendingRequests(_ request: APIRequest) {
    guard request.method == .post else {
      return
    }
    pendingRequests.append(request)
  }

  func isConnectionError(_ error: Error) -> Bool {
    (error as? URLError)?.code == .notConnectedToInternet
  }

  func cancelPendingRequests() async {
    retryTask?.cancel()
    pendingRequests.removeAll()
  }
}
