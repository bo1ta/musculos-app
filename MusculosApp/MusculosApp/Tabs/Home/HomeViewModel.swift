//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Observation
import Storage
import Utility

@Observable
@MainActor
final class HomeViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\.userStore) var userStore: UserStoreProtocol

  private(set) var isLoading = false
  private(set) var challenges: [Challenge] = []
  private(set) var quickExercises: [Exercise]?
  private(set) var errorMessage: String?
  private(set) var notificationTask: Task<Void, Never>?

  var currentUser: UserProfile? {
    userStore.currentUser
  }

  var goals: [Goal] {
    userStore.currentUser?.goals ?? []
  }

  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    do {
      let exercises = try await exerciseRepository.getExercisesByWorkoutGoal(.improveEndurance)
      quickExercises = Array(exercises.prefix(2))
    } catch {
      Logger.error(error, message: "Error loading exercises for home view")
    }
  }
}
