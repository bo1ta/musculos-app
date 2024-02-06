//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation
import Supabase

protocol ExerciseModuleProtocol {
  func getExercises() async throws -> [Exercise]
  func fetchWithImageUrl() async throws -> [Exercise]
  func getImageUrl(exercise: Exercise) async -> URL?
}

struct ExerciseModule: ExerciseModuleProtocol {
  private let supabaseStorage = SupabaseWrapper.shared.storage

  func getExercises() async throws -> [Exercise] {
    return try await SupabaseWrapper.shared.database.rpc("get_exercises").execute().value
  }
  
  func fetchWithImageUrl() async throws -> [Exercise] {
    let exercises = try await getExercises()
    return await exercises.asyncCompactMap { exercise in
      let imageUrl = await getImageUrl(exercise: exercise)

      var newExercise = exercise
      newExercise.setImageUrl(imageUrl)
      return newExercise
    }
  }
  
  func getImageUrl(exercise: Exercise) async -> URL? {
    do {
      let newFileName = "\(exercise.imagePath)/images/0.jpg"
      return try supabaseStorage
        .from(SupabaseConstants.Bucket.workoutImage.rawValue)
        .getPublicURL(path: newFileName)
    } catch {
      MusculosLogger.logError(error: error, message: "signed url problem", category: .supabase)
      return nil
    }
  }
}
