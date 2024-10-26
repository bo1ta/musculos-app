//
//  BaseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation
import Models
import Storage

/// Common type to group repositories
///
protocol BaseRepository { }

extension BaseRepository {
  var currentUserID: UUID? {
    return StorageContainer.shared.userManager().currentUserID
  }
}


