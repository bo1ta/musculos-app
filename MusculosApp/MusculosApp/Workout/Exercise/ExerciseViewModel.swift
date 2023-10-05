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
    @Published var errorMessage: String? = nil
    @Published var isFavorite: Bool = false
        
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
    
    private var exerciseId: Int? {
        return Int(self.exercise.id)
    }
    
    public func loadData() {
        if let localExercise = self.maybeFetchLocal() {
            self.isFavorite = localExercise.isFavorite
        }
    }
    
    public func toggleFavorite() {
        self.isFavorite.toggle()
        
        if let localExercise = self.maybeFetchLocal() {
            localExercise.isFavorite = self.isFavorite
            self.saveLocalChanges()
        } else {
            let exerciseManagedObject = self.exercise.toEntity(context: self.managedObjectContext)
            exerciseManagedObject.isFavorite = self.isFavorite
            self.saveLocalChanges()
        }
    }
    
    private func maybeFetchLocal() -> ExerciseManagedObject? {
        guard let exerciseId = self.exerciseId, let localExercise = try? CoreDataStack.shared.fetchEntitiesByIds(entityName: "ExerciseManagedObject", by: [exerciseId])?.first as? ExerciseManagedObject else {
            return nil
        }
        return localExercise
    }
    
    private func saveLocalChanges() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
