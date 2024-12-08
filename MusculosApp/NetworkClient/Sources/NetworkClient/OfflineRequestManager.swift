//
//  OfflineRequestManager.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Combine
import Foundation
import Factory
import Network
import Utility
import Queue

actor OfflineRequestManager {
  private let queue = AsyncQueue()

  private var pendingRequests: [APIRequest] = []
  private var isInternetAvailable = false
  private nonisolated(unsafe) var cancellable: Cancellable?

  init() {
    cancellable = NetworkContainer.shared.networkMonitor().connectionStatusPublisher
      .sink { [weak self] connectionStatus in
        self?.queue.addOperation { [weak self] in
          await self?.handlePathUpdate(connectionStatus)
        }
      }
  }

  func addToPendingRequests(_ request: APIRequest) {
    pendingRequests.append(request)
  }

  func isConnectionError(_ error: Error) -> Bool {
    return (error as? URLError)?.code == .notConnectedToInternet
  }

  func cancelPendingRequests() async {
    await queue.addBarrierOperation(operation: {})
    pendingRequests.removeAll()
  }

  private func handlePathUpdate(_ connectionStatus: NWPath.Status) async {
    let wasOffline = !isInternetAvailable
    isInternetAvailable = connectionStatus == .satisfied

    if isInternetAvailable && wasOffline {
      await retryPendingRequests()
    }
  }

  private func retryPendingRequests() async {
    let requestsToRetry = pendingRequests
    pendingRequests.removeAll()

    for request in requestsToRetry {
      do {
        let data = try await dispatch(request)
        MusculosLogger.logInfo(message: "Retry succeeded after recovering network connectivity", category: .networking)
      } catch {
        if isConnectionError(error) {
          addToPendingRequests(request)
        }
      }
    }
  }

  private func dispatch(_ request: APIRequest) async throws {
    guard let request = request.asURLRequest() else {
      throw MusculosError.badRequest
    }

    _ = try await URLSession.shared.data(for: request)
  }
}