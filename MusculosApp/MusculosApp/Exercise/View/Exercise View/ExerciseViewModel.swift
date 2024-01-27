//
//  ExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.09.2023.
//

import Foundation
import SwiftUI
import CoreData

final class ExerciseViewModel: ObservableObject {
  @Published var exercise: Exercise
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var isFavorite: Bool = false
  
  private let exerciseResourceManager = ExerciseResourceManager()
  private let managedObjectContext = CoreDataStack.shared.mainContext
  
  private(set) var resourceTask: Task<Void, Never>?
  private(set) var coreDataTask: Task<Void, Never>?

  init(exercise: Exercise) {
    self.exercise = exercise
  }

  private lazy var muscleImageInfo: MuscleImageInfo? = {
    guard let muscleInfo = Array(MuscleData.muscles.values)
        .filter({ $0.name == exercise.bodyPart }).first else { return nil }
    return muscleInfo.imageInfo
  }()

  public var frontMuscles: [Int]? {
    return self.muscleImageInfo?.frontAnatomyIds
  }

  public var backMuscles: [Int]? {
    return self.muscleImageInfo?.backAnatomyIds
  }

  public var shouldShowAnatomyView: Bool {
    return self.backMuscles != nil || self.frontMuscles != nil
  }

  public func toggleFavorite() {
    isFavorite.toggle()
    
    if isFavorite {
      saveResource()
    }

    /// update local exercise if exists or save a new one
    if let localExercise = maybeFetchLocal() {
      localExercise.isFavorite = isFavorite
      saveLocalChanges()
    } else {
      let exerciseManagedObject = exercise.toEntity(context: self.managedObjectContext)
      exerciseManagedObject.isFavorite = isFavorite
      self.saveLocalChanges()
    }
  }
  
  private func cleanUp() {
    coreDataTask?.cancel()
    resourceTask?.cancel()
  }
}

// MARK: - Network

extension ExerciseViewModel {
  private func saveResource() {
    isLoading = true
    defer { isLoading = false }
    
    resourceTask = Task {
      do {
        try await exerciseResourceManager.saveExercise(exercise: exercise, isFavorite: isFavorite)
      } catch {
        MusculosLogger.logError(error: error, message: "Could not save exercise", category: .networking)
      }
    }
  }
}

// MARK: - Core Data

extension ExerciseViewModel {
  @MainActor
  public func loadLocalData() {
    if let localExercise = self.maybeFetchLocal() {
      self.isFavorite = localExercise.isFavorite
    }
  }
  
  private func maybeFetchLocal() -> ExerciseManagedObject? {
    let fetchRequest = NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
    fetchRequest.predicate = (NSPredicate(format: "name == %@", self.exercise.name))

    do {
      let exerciseManagedObject = try self.managedObjectContext.fetch(fetchRequest)
      return exerciseManagedObject.first
    } catch {
      self.errorMessage = errorMessage
      MusculosLogger.logError(error: error, message: "cannot fetch local exercise by name", category: .coreData)
      return nil
    }
  }

  private func saveLocalChanges() {
    coreDataTask = Task {
      do {
        _ = try await CoreDataStack.shared.saveMainContext()
      } catch {
        self.errorMessage = error.localizedDescription
        MusculosLogger.logError(error: error, message: "cannot save local change", category: .coreData)
      }
    }
  }
}
