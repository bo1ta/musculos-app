//
//  AddExerciseSheetViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Models
import NetworkClient
import SwiftUI
import Utility

@Observable
@MainActor
final class AddExerciseSheetViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

  @ObservationIgnored
  @Injected(\.soundManager) private var soundManager: SoundManager

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\NetworkContainer.imageService) private var imageService: ImageServiceProtocol

  private let didSaveSubject = PassthroughSubject<Void, Never>()

  // MARK: Public

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

  var didSavePublisher: AnyPublisher<Void, Never> {
    didSaveSubject.eraseToAnyPublisher()
  }

  private var isExerciseValid: Bool {
    !exerciseName.isEmpty &&
      !equipment.isEmpty &&
      !force.isEmpty &&
      !targetMuscles.isEmpty &&
      !level.isEmpty &&
      !category.isEmpty
  }

  func saveExercise() {
    guard isExerciseValid else {
      toastManager.showWarning("Cannot save exercise with empty fields")
      return
    }

    Task {
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
        imageUrls: imageUrls)

      do {
        try await exerciseRepository.addExercise(exercise)
        didSaveSubject.send(())
      } catch {
        toastManager.showError("Cannot save exercise with empty fields")
        Logger.error(error, message: "Could not save exercise")
      }
    }
  }

  private func uploadImages() async -> [String] {
    guard !pickedPhotos.isEmpty else {
      return []
    }

    var results: [String] = []

    let images = pickedPhotos.map { $0.image }
    for await result in await imageService.uploadImages(images) {
      switch result {
      case .success(let url):
        results.append(url.absoluteString)
      case .failure(let error):
        Logger.error(error, message: "Something went wrong while trying to upload exercise images.")
      }
    }

    return results
  }
}
