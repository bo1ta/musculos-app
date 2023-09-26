//
//  WorkoutManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation
import CoreData

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

// MARK: - Local storage
// First, try fetching them from the Core Data store
// If that fails, make an api request. If successful, save the models to Core Data

extension WorkoutManager {
    func fetchLocalExercises() throws -> [Exercise] {
        do {
            let fetchRequest = NSFetchRequest<ExerciseManagedObject>(entityName: "ExerciseManagedObject")
            let results = try self.context.fetch(fetchRequest)
            return results.map { Exercise(from: $0) }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local exercises", error: error, category: .coreData)
            throw error
        }
    }

    func fetchExercises(offset: Int = 0, limit: Int = 10) async throws -> [Exercise] {
        do {
            let exercises = try await self.exerciseModule.getExercises()
            exercises.forEach { $0.toEntity(context: self.context) }
            try self.context.save()
            MusculosLogger.log(.info, message: "Fetched the exercises: \(exercises)", category: .coreData)
            return exercises
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch exercises", category: .coreData)
            throw error
        }
    }
}
