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
}
