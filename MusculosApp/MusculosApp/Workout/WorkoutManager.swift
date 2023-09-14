//
//  WorkoutManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.09.2023.
//

import Foundation

final class WorkoutManager {
    private let client: MusculosClient
    
    private let equipmentModule: EquipmentModule
    private let muscleModule: MuscleModule
    private let exerciseModule: ExerciseModule
    
    private let dataController = DataController.shared
    
    init(client: MusculosClient = MusculosClient()) {
        self.client = client
        self.equipmentModule = EquipmentModule(client: self.client)
        self.muscleModule = MuscleModule(client: self.client)
        self.exerciseModule = ExerciseModule(client: self.client)
    }
}

// MARK: - Fetching objects
// First, try fetching them from the Core Data store
// If that fails, make an api request. If successful, save the models in Core Data

extension WorkoutManager {
    func fetchAllEquipments() async throws -> [Equipment] {
        do {
            if let equipmentEntities = try await self.dataController.fetchAllEntities(entityName: "EquipmentEntity") as? [EquipmentEntity] {
                return equipmentEntities.map { Equipment.init(entity: $0) }
            } else {
                let equipments = try await self.equipmentModule.getAllEquipment()
                _ = equipments.map { Equipment.toEntity($0) }
                try self.dataController.save()
                return equipments
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch equipments", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchAllMuscles() async throws -> [Muscle] {
        do {
            if let muscleEntities = try await self.dataController.fetchAllEntities(entityName: "MuscleEntity") as? [MuscleEntity] {
                return muscleEntities.map { Muscle.init(entity: $0) }
            } else {
                let muscleResponse = try await self.muscleModule.getAllMuscles()
                let muscles = muscleResponse.results

                _ = muscles.map { Muscle.toEntity($0) }
                try self.dataController.save()
                
                return muscles
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch muscles", error: error, category: .coreData)
            throw error
        }
    }
    
    func fetchLocalExercises() async throws -> [Exercise]? {
        do {
            if let exerciseEntities = try await self.dataController.fetchAllEntities(entityName: "ExerciseEntity") as? [ExerciseEntity] {
                return exerciseEntities.map { Exercise(entity: $0) }
            }
            return nil
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch local exercises", error: error, category: .coreData)
            throw error
        }
    }

    func fetchAllExercises() async throws -> [Exercise] {
        do {
            let exerciseResponse = try await self.exerciseModule.getAllExercise()
            let exercises = exerciseResponse.results
            
            let muscleEntities = try await self.dataController.fetchEntitiesByIds(entityName: "MuscleEntity", by: exercises.flatMap { $0.musclesId }) as? [MuscleEntity]
            let equipmentEntities = try await self.dataController.fetchEntitiesByIds(entityName: "EquipmentEntity", by: exercises.flatMap { $0.equipmentId }) as? [EquipmentEntity]
            
            let newExercises: [Exercise] = exercises.map { exercise in
                var newExercise = exercise
                let exerciseEntity = newExercise.toEntity()
                
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
            
            try self.dataController.save()
            MusculosLogger.log(.info, message: "Fetched the exercises: \(exercises)", category: .coreData)
            return newExercises
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch exercises", category: .coreData)
            throw error
        }
    }
}
