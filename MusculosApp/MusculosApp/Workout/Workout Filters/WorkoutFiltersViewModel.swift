//
//  WorkoutFiltersViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import Foundation
import Combine
import SwiftUI

enum WorkoutFilterType {
  case gender, location, type, body, duration
}

class WorkoutFiltersViewModel: ObservableObject {
  @Published var selectedGenderOption: String = "" {
    didSet {
      if selectedGenderOption == oldValue {
        selectedGenderOption = ""
      }
    }
  }

  @Published var selectedLocationOption: String = "" {
    didSet {
      if selectedLocationOption == oldValue {
        selectedLocationOption = ""
      }
    }
  }

  @Published var selectedTypeOption: String = "" {
    didSet {
      if selectedTypeOption == oldValue {
        selectedTypeOption = ""
      }
    }
  }

  @Published var selectedBodyOption: String = "" {
    didSet {
      if selectedBodyOption == oldValue {
        selectedBodyOption = ""
      }
    }
  }

  @Published var selectedWorkoutDuration: Double = 5
  let workoutTimeRange: ClosedRange<Double> = 5...60

  let genderListItem = SelectListItem(itemTitle: "Gender", options: ["Male", "Female"])
  let locationListItem = SelectListItem(itemTitle: "Location", options: ["Home", "Gym", "Mix"])
  let typeListItem = SelectListItem(itemTitle: "Type", options: ["Daily workout", "Workout plan"])
  let bodyListItem = SelectListItem(itemTitle: "Body", options: ["Chest", "Arms", "Abs", "Legs"])

  func resetState() {
    self.selectedGenderOption = ""
    self.selectedLocationOption = ""
    self.selectedTypeOption = ""
    self.selectedBodyOption = ""
    self.selectedWorkoutDuration = 5
  }
}
