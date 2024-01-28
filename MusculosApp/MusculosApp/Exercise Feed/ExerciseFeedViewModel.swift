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
  
  private let exerciseResourceManager = ExerciseResourceManager()

  private lazy var exerciseModule: ExerciseDBModule = {
    return ExerciseDBModule()
  }()
  
  // MARK: Cache and clean up
  private var usesLocalCache = false
  private var exerciseCache: [Exercise]?
  private var cancellables: Set<AnyCancellable> = []
  
  /// Pagination
  private var currentOffset = 0
  
  /// Used for preview so we don't make unnecessary network requests
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
    guard !overrideLocalPreview, index >= currentExercises.count - 1 else { return }
    
    // go 10 by 10 on the offset
    // since we fetch 10 exercises on each request
    currentOffset += 10
    await loadExercises(offset: currentOffset)
  }

  func loadExercises(offset: Int) async {
    do {
      isLoading = true
      defer { isLoading = false }

      let exercises = try await workoutManager.fetchExercises(offset: offset)
      
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
    Task {
      self.isLoading = true
      defer { self.isLoading = false }
      do {
        self.currentExercises = try await exerciseResourceManager.fetchFavoriteExercises()
      } catch {
        MusculosLogger.logError(error: error, message: "cannot filter exercises", category: .supabase)
      }
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

    let publisher = self.exerciseModule.searchExercise(by: query.lowercased())
    publisher.sink { [weak self] completion in
      switch completion {
      case .finished:
        break
      case .failure(let error):
        self?.errorMessage = error.localizedDescription
      }
    } receiveValue: { [weak self] results in
      self?.currentExercises = results
      self?.isLoading = false
    }
    .store(in: &cancellables)
  }
}
