//
//  ExerciseService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation
import Models
import Storage

protocol ExerciseServiceProtocol: Sendable {
  func getExercises() async throws -> [Exercise]
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise]
}

struct ExerciseService: ExerciseServiceProtocol, MusculosService {
  var client: MusculosClientProtocol

  init(client: MusculosClientProtocol = MusculosClient()) {
    self.client = client
  }
  
  func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, path: .exercises)
    
    let data = try await client.dispatch(request)
    return try Exercise.createArrayFrom(data)
  }
  
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
    var request = APIRequest(method: .get, path: .exercisesByMuscle)
    request.queryParams = [URLQueryItem(name: "query", value: query)]

    let data = try await client.dispatch(request)
    return try Exercise.createArrayFrom(data)
  }
}
