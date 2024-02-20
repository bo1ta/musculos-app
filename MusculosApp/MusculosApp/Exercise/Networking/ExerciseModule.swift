//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation

protocol ExerciseModuleProtocol {
  func getExercises() async throws -> [Exercise]
}

struct ExerciseModule: ExerciseModuleProtocol, MusculosModuleProtocol {
  var client: MusculosClientProtocol

  init(client: MusculosClientProtocol = MusculosClient()) {
    self.client = client
  }
  
  func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, path: .exercises)
    let data = try await client.dispatch(request)
    return try await Exercise.createArrayFrom(data)
  }
}
