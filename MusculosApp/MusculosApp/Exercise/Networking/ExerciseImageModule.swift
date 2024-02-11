//
//  ExerciseImageModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import Foundation

struct ExerciseImageModule: SupabaseModule {
  private func getImagesCount(_ exercise: Exercise) async throws -> Int {
    let files = try await supabaseStorage
      .from(SupabaseConstants.Bucket.workoutImage.rawValue)
      .list(path: exercise.imageFolder)
    return files.count
  }
  
  func loadAllImages(for exercise: Exercise) async throws -> Exercise {
    var newExercise = exercise
    newExercise.clearImages()

    let imagesCount = try await getImagesCount(exercise)
    let imagesPaths = exercise.getImagesPaths(imagesCount)
    imagesPaths.forEach { path in
      let imageUrl = getImageUrl(path: path)
      newExercise.addImageUrl(imageUrl)
    }
    return newExercise
  }
  
  func loadInitialImage(for exercise: Exercise) async throws -> Exercise {
    var newExercise = exercise
    if let imageUrl = getImageUrl(path: newExercise.firstImagePath) {
      newExercise.addImageUrl(imageUrl)
    }
    return newExercise
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
}
