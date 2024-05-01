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
  @Published var selectedLevelFilter: String = ""
  @Published var selectedDuration: Float = 0
  
  @Published var showMuscleFilters: Bool = true
  @Published var showWorkoutFilters: Bool = true
  @Published var showDifficultyFilters: Bool = true
  @Published var showDurationFilter: Bool = true
  @Published var showEquipmentFilter: Bool = true
  
  func resetFilters() {
    selectedMuscleFilters = []
    selectedCategoryFilters = []
    selectedLevelFilter = ""
  }

  private var shouldHandleSearch: Bool {
    searchQuery.count > 0 &&
    selectedMuscleFilters.count > 0 &&
    selectedCategoryFilters.count > 0 &&
    selectedLevelFilter.count > 0 &&
    selectedDuration > 0
  }
}
