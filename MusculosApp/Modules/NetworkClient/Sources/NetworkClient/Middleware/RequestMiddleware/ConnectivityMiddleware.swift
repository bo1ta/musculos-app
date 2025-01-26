//
//  ConnectivityMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Factory
import Foundation
import Utility

struct ConnectivityMiddleware: RequestMiddleware, @unchecked Sendable {
  @Injected(\NetworkContainer.offlineRequestManager) private var offlineManager: OfflineRequestManager

  var priority: MiddlewarePriority { .connectivityMiddleware }

  func intercept(
    request: APIRequest,
    proceed: @escaping (APIRequest) async throws -> (Data, URLResponse))
    async throws -> (Data, URLResponse)
  {
    do {
      return try await proceed(request)
    } catch {
      guard await offlineManager.isConnectionError(error) else {
        throw error
      }

      await offlineManager.addToPendingRequests(request)
      throw MusculosError.offline
    }
  }
}
