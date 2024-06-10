//
//  AddExerciseSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI
import Factory
import Combine

final class AddExerciseSheetViewModel: ObservableObject {
  @Injected(\.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  
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
