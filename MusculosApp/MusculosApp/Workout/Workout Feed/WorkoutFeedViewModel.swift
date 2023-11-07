//
//  WorkoutFeedViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2023.
//

import Foundation
import Combine

@MainActor
final class WorkoutFeedViewModel: ObservableObject {
  @Published var selectedFilter: String = ""
  @Published var selectedExercise: Exercise?
  @Published var errorMessage = ""
  @Published var currentExercises: [Exercise] = []
  @Published var isFiltersPresented = false
  @Published var isExerciseDetailPresented = false
  @Published var isLoading = false
  @Published var searchQuery: String = ""
  @Published var selectedMuscles: [MuscleInfo] = []
  
  // MARK: API
  private lazy var workoutManager: WorkoutManager = {
    return WorkoutManager()
  }()

  private lazy var exerciseModule: ExerciseModule = {
    return ExerciseModule()
  }()
  
  // MARK: Cache and clean up
  private var initialExercises: [Exercise]?
  private var cancellables: Set<AnyCancellable> = []
  
  // MARK: Pagination
  private var currentOffset = 0
  private var totalExercisesAvailable: Int?
  private var exercisesLoadedCount: Int?
  
  // Used for preview so we don't make unnecessary network requests
  var overrideLocalPreview = false

  init() {
    $searchQuery
      .debounce(for: 0.5, scheduler: DispatchQueue.main)
      .sink { [weak self] query in
        if let initialExercises = self?.initialExercises, query == "" {
          self?.currentExercises = initialExercises
        } else {
          self?.searchExercise(with: query)
        }
      }
      .store(in: &cancellables)

    $selectedFilter
      .sink { [weak self] filter in
        self?.filterExercises(by: filter)
      }
      .store(in: &cancellables)
  }

  func filterExercises(by filter: String) {
    switch filter {
    case "Favorites":
      filterFavoriteExercises()
      return
    default:
      if let initialExercises = self.initialExercises {
        currentExercises = initialExercises
      }
      return
    }
  }
  
  func loadLocalExercises() {
    do {
      currentExercises = try workoutManager.fetchLocalExercises()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func loadInitialData() async {
    guard !overrideLocalPreview else {
      loadLocalExercises()
      return
    }
    
    currentOffset = 0
    await loadExercises(offset: currentOffset)
  }
  
  func maybeRequestMoreExercises(index: Int) async {
    // check if the current index meets the threshold
    guard
      !overrideLocalPreview,
      let exercisesLoadedCount = self.exercisesLoadedCount,
      shouldRequestMore(itemsLoadedCount: exercisesLoadedCount, index: index)
    else { return }
    
    // go 10 by 10 for the offset
    // since the request limit is also 10
    currentOffset += 10
    await loadExercises(offset: currentOffset)
  }
  
  private func shouldRequestMore(itemsLoadedCount: Int, index: Int) -> Bool {
    return index >= itemsLoadedCount - 1
  }

  func loadExercises(offset: Int) async {
    do {
      isLoading = true
      defer { isLoading = false }

      let exercises = try await workoutManager.fetchExercises(offset: offset)
      currentExercises.append(contentsOf: exercises)
      exercisesLoadedCount = currentExercises.count
      
      // cache the first result
      if initialExercises == nil {
        initialExercises = exercises
      }
    } catch {
      errorMessage = error.localizedDescription
      MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
    }
  }

  func filterFavoriteExercises() {
    do {
      self.isLoading = true
      defer { self.isLoading = false }

      let exercises = try self.workoutManager.fetchFavoriteExercises()
      self.currentExercises = exercises
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }

  func getExercisesByMuscleType(muscleInfo: MuscleInfo) async {
    do {
      self.isLoading = true
      defer { self.isLoading = false }

      let exercises = try await self.exerciseModule.getExercises(by: muscleInfo)
      self.currentExercises = exercises
    } catch {
      MusculosLogger.log(.error, message: "Error loading exercises", category: .ui)
      self.errorMessage = error.localizedDescription
    }
  }

  func searchExercise(with query: String) {
    guard query.count > 0 else { return }

    self.isLoading = true
    defer { self.isLoading = false }

    let publisher = self.exerciseModule.searchExercise(by: query)
    publisher.sink { [weak self] completion in
      switch completion {
      case .finished:
        break
      case .failure(let error):
        self?.errorMessage = error.localizedDescription
      }
    } receiveValue: { [weak self] results in
      self?.currentExercises = results
    }
    .store(in: &cancellables)
  }
}
