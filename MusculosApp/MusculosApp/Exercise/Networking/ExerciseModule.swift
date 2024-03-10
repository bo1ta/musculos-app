//
//  ExerciseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation

protocol ExerciseModuleProtocol {
  func getExercises() async throws -> [Exercise]
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise]
}

struct ExerciseModule: ExerciseModuleProtocol, MusculosModule {
  var client: MusculosClientProtocol
  var dataImporter: DataImporter

  init(client: MusculosClientProtocol = MusculosClient(), dataImporter: DataImporter = DataImporter()) {
    self.client = client
    self.dataImporter = dataImporter
  }
  
  func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, path: .exercises)
    let data = try await client.dispatch(request)
    return dataImporter.importExercisesUsingData(data)
  }
  
  func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
    var request = APIRequest(method: .get, path: .exercisesByMuscle)
    request.queryParams = [URLQueryItem(name: "query", value: query)]
    let data = try await client.dispatch(request)
    return dataImporter.importExercisesUsingData(data)
  }
}
