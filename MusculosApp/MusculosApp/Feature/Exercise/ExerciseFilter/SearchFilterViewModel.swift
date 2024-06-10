//
//  ExerciseFilterViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine

class ExerciseFilterViewModel: ObservableObject {
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
  enum FilterDisplayable {
    case muscle, category, difficulty, equipment
  }
  
  enum SearchFilterKey: String {
    case muscle, category, equipment
  }
  
  @Published var selectedLevelFilter: String = "" {
    didSet {
      self.filtersChanged.send(())
    }
  }
  
  @Published var filters: [SearchFilterKey: [String]] = [:]
  @Published var results: [Exercise] = []
  
  private let filtersChanged = PassthroughSubject<Void, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  @Published var displayFilter: [FilterDisplayable: Bool] = [
    .muscle: true,
    .category: true,
    .difficulty: true,
    .equipment: true
  ]
  
  private(set) var filterTask: Task<Void, Never>?
  
  init() {
    filtersChanged
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.filterExercises()
      }
      .store(in: &cancellables)
  }

  func makeSearchFilterBinding(for key: SearchFilterKey) -> Binding<[String]> {
    return Binding {
      self.filters[key] ?? []
    } set: { newValue in
      self.filters[key] = newValue
      self.filtersChanged.send(())
    }
  }
  
  func makeFilterDisplayBinding(for filterDisplayable: FilterDisplayable) -> Binding<Bool> {
    return Binding {
      self.displayFilter[filterDisplayable] ?? true
    } set: { newValue in
      self.displayFilter[filterDisplayable] = newValue
    }
  }
  
  func resetFilters() {
    selectedLevelFilter = ""
    filters = [:]
  }
  
  private var shouldHandleSearch: Bool {
    filters.count > 0 ||
    selectedLevelFilter.count > 0
  }
  
  func filterExercises() {
    filterTask?.cancel()
    
    filterTask = Task { @MainActor in
      guard let muscles = filters[.muscle] else { return }
      
      let categories = filters[.category] ?? []
      let equipments = filters[.equipment] ?? []
      
      let muscleTypes = muscles.compactMap { MuscleType(rawValue: $0) }
      var filteredExercises = await self.exerciseDataStore.getByMuscles(muscleTypes)
      
      if categories.count > 0 {
        filteredExercises = filteredExercises.filter { categories.contains($0.category) }
      }
      
      if equipments.count > 0 {
        filteredExercises = filteredExercises.filter { exercise in
          if let equipment = exercise.equipment {
            return equipments.contains(equipment)
          } else {
            return true
          }
        }
      }
      
      if selectedLevelFilter.count > 0 {
        filteredExercises = filteredExercises.filter { $0.level == selectedLevelFilter }
      }
    
      if !filteredExercises.isEmpty {
        results = filteredExercises
      }
    }
  }
  
  func cleanUp() {
    filterTask?.cancel()
    filterTask = nil
  }
}
