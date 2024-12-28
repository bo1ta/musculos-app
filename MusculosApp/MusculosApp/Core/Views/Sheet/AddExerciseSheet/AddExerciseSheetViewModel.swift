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
import DataRepository
import Components

@Observable
@MainActor
final class AddExerciseSheetViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  var exerciseName = ""
  var equipment = ""
  var force = ""
  var level = ""
  var category = ""
  var targetMuscles: [String] = []
  var instructions: [AddDetailOption] = [AddDetailOption(id: 0, text: "")]
  var images: [Image] = []
  var showForceOptions = true
  var showMusclesOptions = true
  var showLevelOptions = true
  var showCategoryOptions = true
  var showEquipmentOptions = true
  var toast: Toast?

  private(set) var saveExerciseTask: Task<Void, Never>?

  var didSavePublisher: AnyPublisher<Void, Never> {
    didSaveSubject.eraseToAnyPublisher()
  }

  private let didSaveSubject = PassthroughSubject<Void, Never>()

  private var isExerciseValid: Bool {
    exerciseName.count > 0 &&
    equipment.count > 0 &&
    force.count > 0 &&
    targetMuscles.count > 0 &&
    level.count > 0 &&
    category.count > 0
  }
  
  func saveExercise(with photos: [PhotoModel] = []) {
    guard isExerciseValid else {
      toast = .warning("Cannot save exercise with empty fields")
      return
    }

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
        try await exerciseRepository.addExercise(exercise)
        didSaveSubject.send(())
      } catch {
        toast = .error("Cannot save exercise with empty fields")
        Logger.error(error, message: "Could not save exercise")
      }
    }
  }

  func onDisappear() {
    saveExerciseTask?.cancel()
  }
}
