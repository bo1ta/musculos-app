//
//  SynchronizationState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.02.2024.
//

import Foundation

/// Helper for handling the synchronization state of objects
///
public enum SynchronizationState: Int {
  case notSynchronized = 0, synchronizationPending, synchronized
}
