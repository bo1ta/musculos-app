//
//  ExerciseResourceManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation
import Supabase

struct ExerciseResourceManager {
  struct FavoriteExercise: Codable {
    let exerciseId: String
    
    enum CodingKeys: String, CodingKey {
      case exerciseId = "exercise_id"
    }
  }
  
  enum ImageContentType: String {
    case gif = "image/gif"
    case image = "image"
  }
  
  enum ImageFormat: String {
    case gif, png
  }
  
  private let supabaseStorage = SupabaseWrapper.shared.storage
  private let client: MusculosClient
  
  init(client: MusculosClient = MusculosClient()) {
    self.client = client
  }
  
  func downloadImageData(from url: URL) async throws -> Data {
    let (data, _) = try await client.urlSession.data(from: url)
    return data
  }
  
  func uploadImageData(
    _ data: Data,
    fileName: String,
    contentType: ImageContentType = .gif
  ) async {
    let fileOptions = FileOptions(contentType: contentType.rawValue)
    do {
      try await supabaseStorage
        .from(SupabaseConstants.Bucket.exerciseImage.rawValue)
        .upload(path: "public/\(fileName)", file: data, options: fileOptions)
    } catch {
      MusculosLogger.logError(error: error, message: "image already exists", category: .supabase)
    }
  }
  
  func createSignedUrl(
    fileName: String,
    format: ImageFormat = .gif,
    path: String = SupabaseConstants.Bucket.exerciseImage.rawValue,
    transformOptions: TransformOptions? = nil
  ) async -> URL? {
    do {
      return try await supabaseStorage
        .from(path)
        .createSignedURL(path: "public/\(fileName).\(format.rawValue)", expiresIn: 180, transform: transformOptions)
    } catch {
      MusculosLogger.logError(error: error, message: "signed url problem", category: .supabase)
      return nil
    }
  }
  
  func saveExercise(
    exercise: Exercise,
    isFavorite: Bool = false
  ) async throws {
    guard let imageUrl = URL(string: exercise.gifUrl) else { return }
    
    /// download image from public API and upload it to Supabase
    await SupabaseWrapper.shared.refreshSession()
    
    let imageData = try await downloadImageData(from: imageUrl)
    await uploadImageData(imageData, fileName: exercise.id)
    
    /// save the object to supabase
    try await SupabaseWrapper.shared.insertData(exercise, table: .exercise)
    
    if isFavorite {
      try await favoriteExercise(exercise: exercise)
    }
  }
  
  func fetchExercise(id: String) async throws -> Exercise? {
    if var exercise: Exercise = try await SupabaseWrapper.shared.fetchById(id: id, table: .exercise) {
      let signedUrl = await createSignedUrl(fileName: exercise.id)
      exercise.gifUrl = signedUrl?.absoluteString ?? exercise.gifUrl
      return exercise
    }
    return nil
  }
  
  func favoriteExercise(exercise: Exercise) async throws {
    do {
      let favoriteExercise = FavoriteExercise(exerciseId: exercise.id)
      try await SupabaseWrapper.shared.insertData(favoriteExercise, table: .favoriteExercise)
    } catch {
      MusculosLogger.logError(error: error, message: "could not favorite", category: .networking)
    }
  }
  
  func fetchFavoriteExercises() async throws -> [Exercise] {
    do {
      let favoriteExercises: [FavoriteExercise] = try await SupabaseWrapper.shared.fetchAll(table: .favoriteExercise)
      let exercises: [Exercise] = try await favoriteExercises.asyncCompactMap { favoriteExercise in
        return try await fetchExercise(id: favoriteExercise.exerciseId)
      }
      return exercises
    } catch {
      MusculosLogger.logError(error: error, message: "Could not fetch favorite exercises", category: .supabase)
    }
    return []
  }
}
