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
  @Published var instructions: [AddDetailOption] = [AddDetailOption(id: 0, text: "")]
  @Published var images: [Image] = []
  @Published var level: String = ""
  @Published var category: String = ""

  @Published var showForceOptions = true
  @Published var showMusclesOptions = true
  @Published var showLevelOptions = true
  @Published var showCategoryOptions = true
  @Published var showEquipmentOptions = true
  
  private var isExerciseValid: Bool {
    exerciseName.count > 0
    && equipment.count > 0
    && force.count > 0 
    && targetMuscles.count > 0
//    && level.count > 0
    && category.count > 0
  }
  
  func createExercise(with photos: [PhotoModel] = []) -> Exercise? {
    guard isExerciseValid else { return nil }
    
    let imageUrls: [String] = photos.compactMap { $0.saveImage()?.absoluteString }
    let instructionsAsString = instructions.map { $0.text }
    
    let exercise = Exercise(
      category: category,
      id: UUID(),
      level: level,
      name: exerciseName,
      primaryMuscles: targetMuscles,
      secondaryMuscles: [],
      instructions: instructionsAsString,
      imageUrls: imageUrls
    )
    return exercise
  }
}
