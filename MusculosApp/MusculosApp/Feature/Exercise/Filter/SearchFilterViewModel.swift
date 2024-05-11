//
//  SearchFilterViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Foundation
import SwiftUI
import Combine

enum SearchFilterKey: String {
  case muscle, category, equipment
}

class SearchFilterViewModel: ObservableObject {
  enum FilterDisplayable {
    case muscle, workout, difficulty, equipment
  }
  
  @Published var selectedLevelFilter: String = ""
  
  @Published var filters: [SearchFilterKey: [String]] = [:]
  @Published var displayFilter: [FilterDisplayable: Bool] = [
    .muscle: true,
    .workout: true,
    .difficulty: true,
    .equipment: true
  ]
  
  
  func makeFilterBinding(for key: SearchFilterKey) -> Binding<[String]> {
    return Binding {
      self.filters[key] ?? []
    } set: { newValue in
      var finalValues = self.filters[key] ?? []
      finalValues.append(contentsOf: newValue)
      
      self.filters[key] = finalValues
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
