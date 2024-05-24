//
//  ExerciseFilterViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Foundation
import SwiftUI
import Combine

class ExerciseFilterViewModel: ObservableObject {
  enum FilterDisplayable {
    case muscle, category, difficulty, equipment
  }
  
  enum SearchFilterKey: String {
    case muscle, category, equipment
  }
  
  @Published var selectedLevelFilter: String = ""
  
  @Published var filters: [SearchFilterKey: [String]] = [:]
  
  @Published var displayFilter: [FilterDisplayable: Bool] = [
    .muscle: true,
    .category: true,
    .difficulty: true,
    .equipment: true
  ]
  
  
  func makeFilterBinding(for key: SearchFilterKey) -> Binding<[String]> {
    return Binding {
      self.filters[key] ?? []
    } set: { newValue in
      self.filters[key] = newValue
    }
  }
  
  func makeDisplayFilterBinding(for filterDisplayable: FilterDisplayable) -> Binding<Bool> {
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
}
