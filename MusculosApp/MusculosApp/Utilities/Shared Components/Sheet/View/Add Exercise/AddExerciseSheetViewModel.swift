//
//  AddExerciseSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI
import Factory
import Combine

@Observable
final class AddExerciseSheetViewModel {
  
  @ObservationIgnored
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
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
  
  var didSaveSubject = PassthroughSubject<Bool, Never>()
    
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
        try await exerciseDataStore.add(exercise)
        await MainActor.run {
          didSaveSubject.send(true)
        }
      } catch {
        await MainActor.run {
          didSaveSubject.send(false)
        }
        MusculosLogger.logError(error, message: "Could not save exercise", category: .coreData)
      }
    }
  }
}
