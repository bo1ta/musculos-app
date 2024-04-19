//
//  AddExerciseSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI

final class AddExerciseSheetViewModel: ObservableObject {
  @Published var exerciseName = ""
  @Published var equipment = ""
  @Published var force = ""
  @Published var targetMuscles: [String] = []
  @Published var instructions: [String] = []
  @Published var images: [Image] = []
  @Published var level: String = ""

  @Published var showForceOptions = true
  @Published var showMusclesOptions = true
  @Published var showLevelOptions = true
}
