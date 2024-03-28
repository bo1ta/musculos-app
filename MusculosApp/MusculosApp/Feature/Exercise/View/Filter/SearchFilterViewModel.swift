//
//  SearchFilterViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Foundation
import SwiftUI
import Combine

class SearchFilterViewModel: ObservableObject {
  @Published var searchQuery: String = ""
  @Published var selectedMuscleFilters: [String] = []
  @Published var selectedCategoryFilters: [String] = []
  @Published var selectedEquipmentFilters: [String] = []
  @Published var selectedDifficultyFilters: [String] = []
  @Published var selectedDuration: Float = 0
  
  @Published var showMuscleFilters: Bool = true
  @Published var showWorkoutFilters: Bool = true
  @Published var showDifficultyFilters: Bool = true
  @Published var showDurationFilter: Bool = true
  @Published var showEquipmentFilter: Bool = true
  
  let muscleFilters = ExerciseConstant.MuscleType.allCases.map { $0.rawValue }
  let forceFilters = ExerciseConstant.ForceType.allCases.map { $0.rawValue }
  let levelFilters = ExerciseConstant.LevelType.allCases.map { $0.rawValue }
  let equipmentFilters = ExerciseConstant.EquipmentType.allCases.map { $0.rawValue }
  let categoryFilters = ExerciseConstant.CategoryType.allCases.map { $0.rawValue }
  
  func resetFilters() {
    selectedMuscleFilters = []
    selectedCategoryFilters = []
    selectedDifficultyFilters = []
  }

  private var shouldHandleSearch: Bool {
    searchQuery.count > 0 &&
    selectedMuscleFilters.count > 0 &&
    selectedCategoryFilters.count > 0 &&
    selectedDifficultyFilters.count > 0 &&
    selectedDuration > 0
  }
}
