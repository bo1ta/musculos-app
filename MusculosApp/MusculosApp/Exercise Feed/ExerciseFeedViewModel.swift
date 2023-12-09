//
//  ExerciseFeedViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2023.
//

import Foundation
import Combine

@MainActor
final class ExerciseFeedViewModel: ObservableObject {
  @Published var selectedFilter: String = ""
  @Published var selectedExercise: Exercise?
  @Published var errorMessage = ""
  @Published var isFiltersPresented = false
  @Published var isExerciseDetailPresented = false
  @Published var isLoading = false
  @Published var searchQuery: String = ""
  @Published var selectedMuscles: [MuscleInfo] = []
  
  @Published var currentExercises: [Exercise] = []

  // MARK: API
  private lazy var workoutManager: WorkoutManager = {
    return WorkoutManager()
  }()

  private lazy var exerciseModule: ExerciseModule = {
    return ExerciseModule()
  }()
  
  // MARK: Cache and clean up
  private var usesLocalCache = false
  private var exerciseCache: [Exercise]?
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
        if let initialExercises = self?.exerciseCache, query == "" {
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
      if let exerciseCache = self.exerciseCache {
        currentExercises = exerciseCache
      }
      return
    }
  }
  
  func loadLocalExercises() {
    do {
      currentExercises = try workoutManager.fetchLocalExercises()
      exerciseCache = currentExercises
      usesLocalCache = true
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func loadInitialData() async {
    loadLocalExercises()

    guard !overrideLocalPreview else {
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
    
    // go 10 by 10 on the offset
    // since we fetch 10 exercises on each request
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
      exercisesLoadedCount = exercises.count
      
      // if using local cache, flush -- the gif images expire after 24 hours
      if usesLocalCache {
        currentExercises = exercises
        exerciseCache = currentExercises // update local cache and keep it for later use
        usesLocalCache = false
      } else {
        currentExercises.append(contentsOf: exercises)
      }

    } catch {
      errorMessage = error.localizedDescription
      MusculosLogger.logError(error: error, message: "Error loading exercises", category: .ui)
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
      MusculosLogger.logError(error: error, message: "Error loading exercises", category: .ui)
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
