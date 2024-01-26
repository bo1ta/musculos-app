//
//  ExerciseResourceManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation
import Supabase

struct ExerciseResourceManager {
  enum ImageContentType: String {
    case gif = "image/gif"
    case image = "image"
  }

  enum ImageFormat: String {
    case gif, png
  }
  
  private let supabaseStorage = SupabaseWrapper.shared.storage
  private let supabaseDatabase = SupabaseWrapper.shared.database
  private let client: MusculosClient
  
  init(client: MusculosClient = MusculosClient()) {
    self.client = client
  }
  
  func downloadImageData(from url: URL) async throws -> Data {
    let (data, _) = try await client.urlSession.data(from: url)
    return data
  }
  
  func uploadImageData(_ data: Data, fileName: String, contentType: ImageContentType = .gif) async throws {
    let fileOptions = FileOptions(contentType: contentType.rawValue)
    try await supabaseStorage
      .from(SupabaseConstants.Bucket.exerciseImage.rawValue)
      .upload(path: "public/\(fileName)", file: data, options: fileOptions)
  }
  
  func createSignedUrl(
    fileName: String,
    format: ImageFormat = .gif,
    path: String = SupabaseConstants.Bucket.exerciseImage.rawValue,
    transformOptions: TransformOptions? = nil
  ) async throws -> URL {
    return try await supabaseStorage
      .from(path)
      .createSignedURL(path: "public/\(fileName).\(format.rawValue)", expiresIn: 180, transform: transformOptions)
  }
  
  func saveExercise(exercise: Exercise) async throws {
    guard let imageUrl = URL(string: exercise.gifUrl) else { return }

    /// download image from public API and upload it to Supabase
    let imageData = try await downloadImageData(from: imageUrl)
    try await uploadImageData(imageData, fileName: exercise.id)
    
    /// save the object to supabase
    try await supabaseDatabase
      .from(SupabaseConstants.Table.exercise.rawValue)
      .insert(exercise)
      .execute()
  }
  
  func fetchExercise(id: String) async throws -> Exercise? {
    let exercises: [Exercise] = try await supabaseDatabase
      .from(SupabaseConstants.Table.exercise.rawValue)
      .select()
      .eq("id", value: id)
      .execute()
      .value
    
    if var exercise = exercises.first {
      let signedUrl = try await createSignedUrl(fileName: exercise.id)
      exercise.gifUrl = signedUrl.absoluteString
      return exercise
    }
    
    return nil
  }
}
