//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import DataRepository
import Factory
import Foundation
import Models
import Observation
import Utility

@Observable
@MainActor
final class HomeViewModel: BaseViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\.goalStore) private var goalStore: GoalStore

  var goals: [Goal] {
    goalStore.goals
  }

  private(set) var isLoading = false
  private(set) var quickExercises: [Exercise]?

  func onAppear() async {
    await fetchData()
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
