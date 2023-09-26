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
    
    private let equipmentModule: EquipmentModule
    private let muscleModule: MuscleModule
    private let exerciseModule: ExerciseModule
        
    init(client: MusculosClient = MusculosClient(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.client = client
        self.context = context
        self.equipmentModule = EquipmentModule(client: self.client)
        self.muscleModule = MuscleModule(client: self.client)
        self.exerciseModule = ExerciseModule(client: self.client)
    }
}

// MARK: - Local storage

extension WorkoutManager {
    func fetchLocalEquipments(with ids: [Int]? = nil) throws -> [EquipmentEntity]? {
        let entityName = "EquipmentEntity"
        let request = NSFetchRequest<EquipmentEntity>(entityName: entityName)
        
        do {
            if let ids = ids {
                let predicate = NSPredicate(format: "id in %@", ids)
                request.predicate = predicate
                return try self.context.fetch(request)
            } else {
                return try self.context.fetch(request)
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local muscles", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchLocalMuscles(with ids: [Int]? = nil) throws -> [MuscleEntity]? {
        let entityName = "MuscleEntity"
        let request = NSFetchRequest<MuscleEntity>(entityName: entityName)

        do {
            if let ids = ids {
                let predicate = NSPredicate(format: "id IN %@", ids)
                request.predicate = predicate
                return try self.context.fetch(request)
            } else {
                return try self.context.fetch(request)
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local muscles", error: error, category: .coreData)
            throw error
        }
    }
}

// MARK: - Fetching `all` objects
// First, try fetching them from the Core Data store
// If that fails, make an api request. If successful, save the models to Core Data

extension WorkoutManager {
    func fetchAllEquipments() async throws -> [Equipment] {
        do {
            if let equipmentEntities = try self.fetchLocalEquipments(), equipmentEntities.count > 0 {
                return equipmentEntities.map { Equipment.init(entity: $0) }
            } else {
                let equipments = try await self.equipmentModule.getAllEquipment()
                _ = equipments.map { $0.toEntity(context: self.context) }
                try self.context.save()
                return equipments
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch equipments", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchMuscles(offset: Int = 0, limit: Int = 10) async throws -> [Muscle] {
        do {
            if let localMuscles = try self.fetchLocalMuscles(), localMuscles.count > 0 {
                return localMuscles.map { Muscle.init(entity: $0) }
            } else {
                let muscleResponse = try await self.muscleModule.getAllMuscles()
                muscleResponse.toEntities(context: self.context)
                try self.context.save()
                return muscleResponse.results
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch muscles", error: error, category: .coreData)
            throw error
        }
    }
    
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
