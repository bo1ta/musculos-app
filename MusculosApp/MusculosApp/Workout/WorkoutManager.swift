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
            if let equipmentEntities = try await self.dataController.fetchEquipment() {
                return equipmentEntities.map { Equipment.init(entity: $0) }
            } else {
                let equipmentResponse = try await self.equipmentModule.getAllEquipment()
                let equipments = equipmentResponse.results

                _ = equipments.map { Equipment.toEntity($0) }
                try self.dataController.save()

                return equipments
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch equipments", category: .coreData)
            throw error
        }
    }
    
    func getAllMuscles() async throws -> [Muscle] {
        do {
            if let muscleEntities = try await self.dataController.fetchMuscles() {
                return muscleEntities.map { Muscle.init(entity: $0) }
            } else {
                let muscleResponse = try await self.muscleModule.getAllMuscles()
                let muscles = muscleResponse.results

                _ = muscles.map { Muscle.toEntity($0) }
                try self.dataController.save()
                
                return muscles
            }
        } catch {
            MusculosLogger.log(.error, message: "Could not fetch muscles", category: .coreData)
            throw error
        }
    }
}
