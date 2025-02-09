//
//  ExploreViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Combine
import DataRepository
import Factory
import Models
import Observation
import Storage
import Utility

// MARK: - ExploreViewModel

@Observable
@MainActor
final class ExploreViewModel: BaseViewModel, TabViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository

  // MARK: Public

  private(set) var featuredExercises = LoadingViewState<[Exercise]>.empty
  private(set) var recommendedExercisesByGoals = LoadingViewState<[Exercise]>.empty
  private(set) var recommendedExercisesByPastSessions = LoadingViewState<[Exercise]>.empty

  private(set) var searchQueryTask: Task<Void, Never>?

  var shouldLoad: Bool {
    featuredExercises.isLoadable
      || recommendedExercisesByGoals.isLoadable
      || recommendedExercisesByPastSessions.isLoadable
  }

  // MARK: Tasks

  func initialLoad() async {
    guard shouldLoad else {
      return
    }

    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        await self.loadFeaturedExercises()
      }
      group.addTask {
        await self.loadRecommededByGoals()
      }
      group.addTask {
        await self.loadRecommendedByPastSessions()
      }
    }
  }

  private func loadFeaturedExercises() async {
    guard featuredExercises.isLoadable else {
      return
    }

    featuredExercises = .loading

    for await result in await exerciseRepository.getExercisesStream() {
      switch result {
      case .success(let exercises):
        featuredExercises.assignResult(exercises)
      case .failure(let error):
        featuredExercises = .error(error)
        Logger.error(error, message: "Something went wrong while loading featured exercises")
      }
    }
  }

  private func loadRecommededByGoals() async {
    guard recommendedExercisesByGoals.isLoadable else {
      return
    }

    recommendedExercisesByGoals = .loading

    let exercises = await exerciseRepository.getRecommendedExercisesByGoals()
    recommendedExercisesByGoals.assignResult(exercises)
  }

  private func loadRecommendedByPastSessions() async {
    guard recommendedExercisesByPastSessions.isLoadable else {
      return
    }

    recommendedExercisesByPastSessions = .loading

    do {
      let exercises = try await exerciseRepository.getRecommendedExercisesByMuscleGroups()
      recommendedExercisesByPastSessions.assignResult(exercises)
    } catch {
      recommendedExercisesByPastSessions = .error(error)
      Logger.error(error, message: "Something went wrong while loading recommended exercises by muscle groups")
    }
  }

  func searchByMuscleQuery(_ query: String) {
    searchQueryTask = Task {
      do {
        let exercises = try await exerciseRepository.searchByQuery(query)
        featuredExercises.assignResult(exercises)
      } catch {
        Logger.error(error, message: "Could not search by muscle query", properties: ["query": query])
      }
    }
  }

  func setFilteredExercises(_ exercises: [Exercise]) {
    featuredExercises.assignResult(exercises)
  }

  func cleanUp() {
    searchQueryTask?.cancel()
  }
}
