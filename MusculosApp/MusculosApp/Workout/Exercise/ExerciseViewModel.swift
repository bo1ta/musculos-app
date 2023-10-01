////
////  ExerciseViewModel.swift
////  MusculosApp
////
////  Created by Solomon Alexandru on 24.09.2023.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor
//final class ExerciseViewModel: ObservableObject {
//    let previewExercise: SearchExerciseResponse.PreviewExercise
//    let workoutManager: WorkoutManager
//    
//    @Published var fetchedExercise: Exercise? = nil
//    @Published var isLoading = false
//    @Published var errorMessage: String? = nil
//    
//    init(previewExercise: SearchExerciseResponse.PreviewExercise,
//         workoutManager: WorkoutManager = WorkoutManager()) {
//        self.previewExercise = previewExercise
//        self.workoutManager = workoutManager
//    }
//    
//    var frontMuscles: [Int]? {
//        guard let exercise = self.fetchedExercise else { return nil }
//        return exercise.muscles.filter { $0.isFront }.map { $0.id }
//    }
//    
//    var backMuscles: [Int]? {
//        guard let exercise = self.fetchedExercise else { return nil }
//        return exercise.muscles.filter { !$0.isFront }.map { $0.id }
//    }
//    
//    func fetchExercise() {
//        Task {
//            do {
//                self.isLoading = true
//                let exercise = try await self.workoutManager.fetchExercise(by: previewExercise.id)
//                self.fetchedExercise = exercise
//                self.isLoading = false
//            } catch {
//                self.isLoading = false
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//}
