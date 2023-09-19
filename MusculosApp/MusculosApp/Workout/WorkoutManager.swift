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
    func fetchLocalEquipments(with ids: [Int]? = nil) async throws -> [EquipmentEntity]? {
        let entityName = "EquipmentEntity"
        do {
            if let ids = ids {
                return try await self.context.fetchEntitiesByIds(entityName: entityName, by: ids) as? [EquipmentEntity]
            } else {
                return try await self.context.fetchAllEntities(entityName: entityName) as? [EquipmentEntity]
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local muscles", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchLocalExercises() async throws -> [ExerciseEntity]? {
        do {
            return try await self.context.fetchAllEntities(entityName: "ExerciseEntity") as? [ExerciseEntity]
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local exercises", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchLocalMuscles(with ids: [Int]? = nil) async throws -> [MuscleEntity]? {
        let entityName = "MuscleEntity"
        do {
            if let ids = ids {
                return try await self.context.fetchEntitiesByIds(entityName: entityName, by: ids) as? [MuscleEntity]
            } else {
                return try await self.context.fetchAllEntities(entityName: entityName) as? [MuscleEntity]
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
            if let equipmentEntities = try await self.fetchLocalEquipments(), equipmentEntities.count > 0 {
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
    
    func fetchAllMuscles() async throws -> [Muscle] {
        do {
            if let localMuscles = try await self.fetchLocalMuscles(), localMuscles.count > 0 {
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

    func fetchAllExercises() async throws -> [Exercise] {
        do {
            let exerciseResponse = try await self.exerciseModule.getAllExercise()
            let exercises = exerciseResponse.results
            
            let muscleEntities = try await self.fetchLocalMuscles(with: exercises.flatMap { $0.musclesId } )
            let equipmentEntities = try await self.fetchLocalEquipments(with: exercises.flatMap { $0.equipmentId} )
            
            let newExercises: [Exercise] = exercises.map { exercise in
                var newExercise = exercise
                let exerciseEntity = newExercise.toEntity(context: self.context)
                
                if let filteredMuscleEntities = muscleEntities?.filter({ exercise.musclesId.contains($0.id) }) {
                    let muscleSet = Set(arrayLiteral: filteredMuscleEntities)
                    exerciseEntity.muscles = muscleSet as NSSet
                    newExercise.muscles = filteredMuscleEntities.map { Muscle(entity: $0) }
                }
                
                if let filteredEquipmentEntities = equipmentEntities?.filter({ exercise.equipmentId.contains($0.id) }) {
                    let equipmentSet = Set(arrayLiteral: filteredEquipmentEntities)
                    exerciseEntity.equipments = equipmentSet as NSSet
                    newExercise.equipments = filteredEquipmentEntities.map { Equipment(entity: $0) }
                }
                                
                return newExercise
            }
            
            try self.context.save()
            MusculosLogger.log(.info, message: "Fetched the exercises: \(exercises)", category: .coreData)
            return newExercises
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch exercises", category: .coreData)
            throw error
        }
    }
}
