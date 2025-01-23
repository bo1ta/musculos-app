//
//  ExerciseFilterSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI

@Observable
@MainActor
class ExerciseFilterSheetViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  enum FilterDisplayable {
    case muscle, category, difficulty, equipment
  }

  enum SearchFilterKey: String {
    case muscle, category, equipment
  }

  var selectedLevelFilter = "" {
    didSet {
      filtersChanged.send(())
    }
  }

  var filters: [SearchFilterKey: [String]] = [:]
  var results: [Exercise] = []

  private let filtersChanged = PassthroughSubject<Void, Never>()
  private var cancellables = Set<AnyCancellable>()

  var displayFilter: [FilterDisplayable: Bool] = [
    .muscle: true,
    .category: true,
    .difficulty: true,
    .equipment: true,
  ]

  init() {
    filtersChanged
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.filterExercises()
      }
      .store(in: &cancellables)
  }

  func makeSearchFilterBinding(for key: SearchFilterKey) -> Binding<[String]> {
    Binding {
      self.filters[key] ?? []
    } set: { newValue in
      self.filters[key] = newValue
      self.filtersChanged.send(())
    }
  }

  func makeFilterDisplayBinding(for filterDisplayable: FilterDisplayable) -> Binding<Bool> {
    Binding {
      self.displayFilter[filterDisplayable] ?? true
    } set: { newValue in
      self.displayFilter[filterDisplayable] = newValue
    }
  }

  func resetFilters() {
    selectedLevelFilter = ""
    filters = [:]
  }

  func filterExercises() {
    guard let muscles = filters[.muscle] else {
         return
    }

    Task {
      let categories = filters[.category] ?? []
      let equipments = filters[.equipment] ?? []

      let muscleTypes = muscles.compactMap { MuscleType(rawValue: $0) }
      var filteredExercises = await exerciseRepository.getExercisesForMuscleTypes(muscleTypes)

      if !categories.isEmpty {
        filteredExercises = filteredExercises.filter { categories.contains($0.category) }
      }

      if !equipments.isEmpty {
        filteredExercises = filteredExercises.filter { exercise in
          if let equipment = exercise.equipment {
            equipments.contains(equipment)
          } else {
            true
          }
        }
      }

      if !selectedLevelFilter.isEmpty {
        filteredExercises = filteredExercises.filter { $0.level == selectedLevelFilter }
      }

      if !filteredExercises.isEmpty {
        results = filteredExercises
      }
    }
  }
}
