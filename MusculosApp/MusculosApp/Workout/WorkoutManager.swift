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
    
    func fetchLocalExercises() throws -> [ExerciseEntity]? {
        do {
            let request = NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
            return try self.context.fetch(request)
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local exercises", error: error, category: .coreData)
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
    
    func fetchAllMuscles() async throws -> [Muscle] {
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

    func fetchAllExercises() async throws -> [Exercise] {
        do {
            let exerciseResponse = try await self.exerciseModule.getAllExercise()
            let exercises = exerciseResponse.results
            
            guard let muscleEntities: [MuscleEntity] = try self.fetchLocalMuscles(with: exercises.flatMap { $0.musclesId} ), let equipmentEntities: [EquipmentEntity] = try self.fetchLocalEquipments(with: exercises.flatMap { $0.equipmentId} )  else { return [] }
            
            
            let newExercises: [Exercise] = exercises.map { exercise in
                var newExercise = exercise
                let exerciseEntity = newExercise.toEntity(context: self.context)
                
                if !muscleEntities.isEmpty {
                    print(muscleEntities)
                    print(muscleEntities[0].englishName)
                    let muscleSet: Set<MuscleEntity> = Set(muscleEntities)
                    exerciseEntity.muscles = muscleSet as NSSet
                    newExercise.muscles = muscleEntities.map { Muscle(entity: $0) }
                }
                
                if !equipmentEntities.isEmpty {
                    let equipmentSet = Set(equipmentEntities)
                    exerciseEntity.equipments = equipmentSet as NSSet
                    newExercise.equipments = equipmentEntities.map { Equipment(entity: $0) }
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
