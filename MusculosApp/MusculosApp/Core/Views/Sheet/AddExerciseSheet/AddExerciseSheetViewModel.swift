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
import NetworkClient

@Observable
@MainActor
final class AddExerciseSheetViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\NetworkContainer.imageService) private var imageService: ImageServiceProtocol

  var exerciseName = ""
  var equipment = ""
  var force = ""
  var level = ""
  var category = ""
  var targetMuscles: [String] = []
  var instructions = [AddDetailOption(id: 0, text: "")]
  var showForceOptions = true
  var showMusclesOptions = true
  var showLevelOptions = true
  var showCategoryOptions = true
  var showEquipmentOptions = true
  var pickedPhotos: [PhotoModel] = []
  var showPhotoPicker = false
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

  private func uploadImages() async -> [String] {
    var results = [String]()

    let images = pickedPhotos.map { $0.image }
    for image in images {
      do {
        let imageURL = try await imageService.uploadImage(image: image)
        results.append(imageURL.absoluteString)
      } catch {
        Logger.error(error, message: "Error uploading image.")
      }
    }

    return results
  }

  func saveExercise() {
    guard isExerciseValid else {
      toast = .warning("Cannot save exercise with empty fields")
      return
    }

    saveExerciseTask = Task { [weak self] in
      guard let self else {
        return
      }

      let imageUrls = await uploadImages()
      let instructionsString = instructions.map { $0.text }
      
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
