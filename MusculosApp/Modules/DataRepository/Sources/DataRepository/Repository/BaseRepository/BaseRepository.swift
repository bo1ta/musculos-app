//
//  BaseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import NetworkClient

/// Protocol defining the base requirements for a repository
///
protocol BaseRepository: Sendable {

  /// The sync manager responsible for handling data synchronization between local and remote storage
  ///
  var syncManager: SyncManagerProtocol { get }

  /// The network monitor responsible for tracking the device's internet connectivity status
  ///
  var networkMonitor: NetworkMonitorProtocol { get }

  /// The user sesion manager responsible for managing the current user's session and ID
  ///
  var userManager: UserSessionManagerProtocol { get }
}
