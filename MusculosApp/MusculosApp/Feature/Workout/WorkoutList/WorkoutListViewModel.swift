//
//  WorkoutListViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.05.2024.
//

import Foundation
import SwiftUI
import Utility
import Storage
import Models
import Factory

@Observable
@MainActor
final class WorkoutListViewModel {

  @ObservationIgnored
  @Injected(\StorageContainer.workoutDataStore) private var dataStore: WorkoutDataStoreProtocol

  var state: LoadingViewState<[Workout]> = .empty
  var searchQuery: String = ""

  private(set) var loadTask: Task<Void, Never>?
  
  var isLoading: Bool {
    return state == .loading
  }
  
  func initialLoad() {
    loadTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      let workouts = await dataStore.getAll()
      
      if workouts.count > 0 {
        state = .loaded(workouts)
      } else {
        state = .error("No workouts found!")
      }
    }
  }
}
