//
//  WorkoutManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import CoreData
import Combine

final class WorkoutManager {
  private let client: MusculosClient
  private let context: NSManagedObjectContext
  private let exerciseModule: ExerciseModule

  init(client: MusculosClient = MusculosClient(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.client = client
    self.context = context
    self.exerciseModule = ExerciseModule(client: self.client)
  }
}

extension WorkoutManager {
  func fetchLocalExercises() throws -> [Exercise] {
    do {
      let fetchRequest = NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
      let results = try self.context.fetch(fetchRequest)
      return results.map { Exercise(from: $0) }
    } catch {
      MusculosLogger.logError(error: error, message: "Could not fetch local exercises", category: .coreData)
      throw error
    }
  }

  func fetchFavoriteExercises() throws -> [Exercise] {
    let fetchRequest = NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
    fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
    do {
      let favoriteExercises = try self.context.fetch(fetchRequest)
      let mappedObjects = favoriteExercises.map { Exercise(from: $0) }
      return mappedObjects
    } catch {
      MusculosLogger.logError(error: error, message: "Could not fetch favorite exercises", category: .coreData)
      throw error
    }
  }

  func fetchExercises(offset: Int = 0, limit: Int = 10) async throws -> [Exercise] {
    do {
      let exercises = try await self.exerciseModule.getExercises(offset: offset, limit: limit)
      _ = try exercises.forEach {
        try self.maybeSaveExercise($0)
      }
      MusculosLogger.logInfo(message: "Fetched the exercises: \(exercises)", category: .coreData)
      return exercises
    } catch {
      MusculosLogger.logError(error: error, message: "Could not fetch exercises", category: .coreData)
      throw error
    }
  }

  private func maybeSaveExercise(_ exercise: Exercise) throws {
    let fetchRequest = NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "name LIKE %@", exercise.name)
    if let _ = try self.context.fetch(fetchRequest).first {
      MusculosLogger.logInfo(message: "Exercise already exists", category: .coreData)
    } else {
      _ = exercise.toEntity(context: self.context)
      try self.context.save()
    }
  }
}
