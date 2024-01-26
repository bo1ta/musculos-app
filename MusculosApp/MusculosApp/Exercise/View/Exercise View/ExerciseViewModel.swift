//
//  ExerciseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.09.2023.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
final class ExerciseViewModel: ObservableObject {
  @Published var exercise: Exercise
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var isFavorite: Bool = false
  
  private let exerciseResourceManager = ExerciseResourceManager()
  
  private(set) var resourceTask: Task<Void, Never>?

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

  private var managedObjectContext: NSManagedObjectContext {
    return CoreDataStack.shared.mainContext
  }

  public var backMuscles: [Int]? {
    return self.muscleImageInfo?.backAnatomyIds
  }

  public var shouldShowAnatomyView: Bool {
    return self.backMuscles != nil || self.frontMuscles != nil
  }

  public func loadData() {
    if let localExercise = self.maybeFetchLocal() {
      self.isFavorite = localExercise.isFavorite
    }
  }
  
  private func saveResource() {
    isLoading = true
    defer { isLoading = false }
    
    resourceTask = Task {
      do {
        try await exerciseResourceManager.saveExercise(exercise: exercise)
        MusculosLogger.logInfo(message: "super merge!", category: .networking)
      } catch {
        errorMessage = errorMessage
      }
    }
  }

  public func toggleFavorite() {
    isFavorite.toggle()
    
    if isFavorite {
      saveResource()
    }

    if let localExercise = maybeFetchLocal() {
      localExercise.isFavorite = isFavorite
      saveLocalChanges()
    } else {
      let exerciseManagedObject = exercise.toEntity(context: self.managedObjectContext)
      exerciseManagedObject.isFavorite = isFavorite
      self.saveLocalChanges()
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
    Task {
      do {
        _ = try await CoreDataStack.shared.saveMainContext()
      } catch {
        self.errorMessage = error.localizedDescription
        MusculosLogger.logError(error: error, message: "cannot save local change", category: .coreData)
      }
    }
  }
}
