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
// If that fails, make an api request. If successful, save the models in the Core Data store

extension WorkoutManager {
    func fetchAllEquipment() async throws -> [Equipment]? {
        do {
            if let equipmentEntities = try await DataController.shared.fetchEquipment() {
                return equipmentEntities.map { Equipment.init(entity: $0) }
            } else {
                let equipmentResponse = try await self.equipmentModule.getAllEquipment()
                let equipments = equipmentResponse.results
                _ = equipments.map { Equipment.toEntity($0) }
                try self.dataController.save()
                return equipments
            }
        } catch {
            print("Error fetching equipment from workout manager: ", error.localizedDescription)
            throw error
        }
    }
}
