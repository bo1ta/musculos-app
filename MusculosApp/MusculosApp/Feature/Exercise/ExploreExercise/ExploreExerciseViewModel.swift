//
//  ExploreExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.04.2024.
//

import Foundation
import SwiftUI

final class ExploreExerciseViewModel: ObservableObject {
  @Published var searchQuery = ""
  @Published var showFilterView = false
  @Published var showExerciseDetails = false
  @Published var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }
}
