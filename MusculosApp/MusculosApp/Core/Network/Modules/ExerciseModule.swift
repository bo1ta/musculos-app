//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation

protocol ExerciseModuleProtocol {
  var dataStore: ExerciseDataStoreProtocol { get set }
  func getExercises() async throws -> [Exercise]
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise]
}

struct ExerciseModule: ExerciseModuleProtocol, MusculosModule {
  var client: MusculosClientProtocol
  var dataStore: ExerciseDataStoreProtocol

  init(client: MusculosClientProtocol = MusculosClient(), dataStore: ExerciseDataStoreProtocol = ExerciseDataStore()) {
    self.client = client
    self.dataStore = dataStore
  }
  
  func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, path: .exercises)
    
    let data = try await client.dispatch(request)
    let results = try Exercise.createArrayFrom(data)
    return await dataStore.importFrom(results)
  }
  
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
    var request = APIRequest(method: .get, path: .exercisesByMuscle)
    request.queryParams = [URLQueryItem(name: "query", value: query)]

    let data = try await client.dispatch(request)
    let results = try Exercise.createArrayFrom(data)
    return await dataStore.importFrom(results)
  }
}
