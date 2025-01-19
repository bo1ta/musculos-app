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
final class HomeViewModel: BaseViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

  @ObservationIgnored
  @Injected(\.goalStore) private var goalStore: GoalStore

  private var cancellable: AnyCancellable?
//  private var goalsListener: FetchedResultsPublisher<GoalEntity>?

  private(set) var isLoading = false
  private(set) var quickExercises: [Exercise]?
  var goals: [Goal] {
    goalStore.goals
  }

  func onAppear() async {
//    setupGoalsListener()
    await fetchData()
  }

  func onDisappear() {
    cancellable?.cancel()
//    goalsListener = nil
  }

//  private func setupGoalsListener() {
//    goalsListener = coreDataStore.fetchedResultsPublisher()
//    cancellable = goalsListener?.publisher
//      .sink { [weak self] event in
//        switch event {
//        case .didUpdateContent(let goals):
//          self?.goals = goals
//        default:
//          break
//        }
//      }
//  }

  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    do {
      let exercises = try await exerciseRepository.getExercisesByWorkoutGoal(.improveEndurance)
      quickExercises = Array(exercises.prefix(2))

//      goals = goalsListener?.fetchedObjects ?? []
    } catch {
      Logger.error(error, message: "Error loading exercises for home view")
    }
  }
}
