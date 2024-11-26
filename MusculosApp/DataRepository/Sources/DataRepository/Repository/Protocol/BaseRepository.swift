//
//  BaseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation
import Models
import Storage
import NetworkClient

/// Common type to group repositories
///
protocol BaseRepository { }

extension BaseRepository {
  var currentUserID: UUID? {
    return StorageContainer.shared.userManager().currentUserID
  }

  var networkMonitor: NetworkMonitorProtocol {
    return NetworkContainer.shared.networkMonitor()
  }

  var isConnectedToInternet: Bool {
    return networkMonitor.isConnected
  }
}


