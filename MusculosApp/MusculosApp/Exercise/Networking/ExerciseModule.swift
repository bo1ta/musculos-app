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
  func getFilteredExercises(filters: [String: [String]]) async throws -> [Exercise]
  func loadImageUrl(for exercises: [Exercise]) async throws -> [Exercise]
  func searchFor(query: String) async throws -> [Exercise]
}

struct ExerciseModule: ExerciseModuleProtocol, SupabaseModule {
  func getExercises() async throws -> [Exercise] {
    let exercises: [Exercise] = try await supabaseDatabase.rpc("get_exercises").execute().value
    return try await loadImageUrl(for: exercises)
  }
  
  func loadImageUrl(for exercises: [Exercise]) async throws -> [Exercise] {
    return try await exercises.asyncCompactMap { exercise in
      var newExercise = exercise
      
      let imagesCount = try await getImagesCount(exercise)
      let imagesPaths = exercise.getImagesPaths(imagesCount)
      imagesPaths.forEach { path in
        let imageUrl = getImageUrl(path: path)
        newExercise.addImageUrl(imageUrl)
      }
      return newExercise
    }
  }
  
  func getImageUrl(path: String) -> URL? {
    do {
      return try supabaseStorage
        .from(SupabaseConstants.Bucket.workoutImage.rawValue)
        .getPublicURL(path: path)
    } catch {
      MusculosLogger.logError(error: error, message: "could not get image url", category: .supabase)
      return nil
    }
  }
  
  func getFilteredExercises(filters: [String: [String]]) async throws -> [Exercise] {
    var query = await supabaseDatabase
      .from(SupabaseConstants.Table.exercises.rawValue)
      .select()
    
    if let equipment = filters["equipment"] {
      query = query.filter("equipment", operator: .cs, value: createFilterQueryString(equipment))
    }
    if let muscles = filters["muscles"] {
      query = query.filter("primary_muscles", operator: .cs, value: createFilterQueryString(muscles))
    }
    if let category = filters["category"] {
      query = query.filter("category", operator: .cs, value: createFilterQueryString(category))
    }
    if let level = filters["level"]?.first {
      query = query.eq("level", value: level)
    }

    let exercises: [Exercise] = try await query.execute().value
    return try await loadImageUrl(for: exercises)
  }
  
  func searchFor(query: String) async throws -> [Exercise] {
    let exercises: [Exercise] = try await supabaseDatabase
      .from(SupabaseConstants.Table.exercises.rawValue)
      .select()
      .textSearch("name", query: query, config: nil, type: .none)
      .limit(10)
      .execute()
      .value
    return try await loadImageUrl(for: exercises)
  }
  
  private func createFilterQueryString(_ list: [String]) -> URLQueryRepresentable {
    return StringListQueryRepresentable(list: list)
  }
  
  private func getImagesCount(_ exercise: Exercise) async throws -> Int {
    let files = try await supabaseStorage
      .from(SupabaseConstants.Bucket.workoutImage.rawValue)
      .list(path: exercise.imageFolder)
    return files.count
  }
}
