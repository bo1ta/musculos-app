//
//  BaseRepository+Common.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Foundation
import NetworkClient
import Utility

// MARK: Common properties / dependencies

extension BaseRepository {

  /// The `NetworkMonitor` shared instance
  ///
  var networkMonitor: NetworkMonitorProtocol {
    NetworkContainer.shared.networkMonitor()
  }

  /// Indicates whether the device is currently connected to the internet
  ///
  var isConnectedToInternet: Bool {
    networkMonitor.isConnected
  }

  /// The `UserSessionManager` shared instance
  ///
  var userManager: UserSessionManagerProtocol {
    NetworkContainer.shared.userManager()
  }

  /// The current user ID, if exists
  ///
  var currentUserID: UUID? {
    userManager.currentUserID
  }

  /// Ensures that a current user ID is available and returns it.
  /// - Throws: `MusculosError.unexpectedNil` if no user ID is found
  /// - Returns: The current user's ID
  ///
  func requireCurrentUser() throws -> UUID {
    guard let userID = currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return userID
  }
}
