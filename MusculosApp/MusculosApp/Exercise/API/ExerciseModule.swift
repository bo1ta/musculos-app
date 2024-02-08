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
  func getFilteredExercises(filter: String) async throws -> [Exercise]
  func loadImageUrl(for exercises: [Exercise]) async throws -> [Exercise] 
  func getImageUrl(exercise: Exercise) async -> URL?
}

struct ExerciseModule: ExerciseModuleProtocol {
  private let supabaseStorage = SupabaseWrapper.shared.storage
  private let supabaseDatabase = SupabaseWrapper.shared.database
  
  func getExercises() async throws -> [Exercise] {
    let exercises: [Exercise] = try await SupabaseWrapper.shared.database.rpc("get_exercises").execute().value
    return loadImageUrl(for: exercises)
  }
  
  func loadImageUrl(for exercises: [Exercise]) -> [Exercise] {
    return exercises.compactMap { exercise in
      let imageUrl = getImageUrl(exercise: exercise)
      
      var newExercise = exercise
      newExercise.setImageUrl(imageUrl)
      return newExercise
    }
  }
  
  func getImageUrl(exercise: Exercise) -> URL? {
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
  
  func getFilteredExercises(filter: String) async throws -> [Exercise] {
    let exercises: [Exercise] = try await SupabaseWrapper.shared.database
      .from(SupabaseConstants.Table.exercises.rawValue)
      .select()
      .eq("equipment", value: filter)
      .execute()
      .value
    return loadImageUrl(for: exercises)
  }
}
