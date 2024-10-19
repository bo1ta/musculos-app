//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Observation
import Storage
import Models
import Utility
import Factory

@Observable
final class HomeViewModel {
  @ObservationIgnored
  @Injected(\StorageContainer.dataController) private var dataController

  private(set) var currentUser: UserProfile?
  private(set) var isLoading = false
  private(set) var recommendedExercises: [Exercise] = []
  private(set) var challenges: [Challenge] = []
  private(set) var goals: [Goal] = []
  private(set) var errorMessage: String?

  @MainActor
  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        self.goals = await self.dataController.getGoals()
      }
      group.addTask {
        self.recommendedExercises = await self.dataController.getExercises()
      }
    }
  }
}
