//
//  AddExerciseSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI
import Factory
import Combine
import Models
import Utility
import Storage

@Observable
@MainActor
final class AddExerciseSheetViewModel {
  
  @ObservationIgnored
  @Injected(\.dataController) private var dataController: DataController

  var exerciseName = ""
  var equipment = ""
  var force = ""
  var targetMuscles: [String] = []
  var instructions: [AddDetailOption] = [AddDetailOption(id: 0, text: "")]
  var images: [Image] = []
  var level: String = ""
  var category: String = ""

  var showForceOptions = true
  var showMusclesOptions = true
  var showLevelOptions = true
  var showCategoryOptions = true
  var showEquipmentOptions = true
  
  private(set) var saveExerciseTask: Task<Void, Never>?

  let didSavePublisher = PassthroughSubject<Void, Never>()

  private var isExerciseValid: Bool {
    exerciseName.count > 0 &&
    equipment.count > 0 &&
    force.count > 0 &&
    targetMuscles.count > 0 &&
    level.count > 0 &&
    category.count > 0
  }
  
  func saveExercise(with photos: [PhotoModel] = []) {
    guard isExerciseValid else { return }
    
    saveExerciseTask = Task {
      let imageUrls = photos.compactMap {
        PhotoWriter.saveImage($0.image, with: $0.id.uuidString)?.absoluteString
      }
      let instructionsString = self.instructions.map { $0.text }
      
      let exercise = Exercise(
        category: category,
        id: UUID(),
        level: level,
        name: exerciseName,
        primaryMuscles: targetMuscles,
        secondaryMuscles: [],
        instructions: instructionsString,
        imageUrls: imageUrls
      )
      
      do {
        try await dataController.addExercise(exercise)
        didSavePublisher.send(())
      } catch {
        MusculosLogger.logError(error, message: "Could not save exercise", category: .coreData)
      }
    }
  }
}
