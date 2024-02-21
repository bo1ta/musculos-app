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
  var dataImporter: DataImporter

  init(client: MusculosClientProtocol = MusculosClient(), dataImporter: DataImporter) {
    self.client = client
    self.dataImporter = dataImporter
  }
  
  func getExercises() async throws -> [Exercise] {
    let request = APIRequest(method: .get, path: .exercises)
    let data = try await client.dispatch(request)
    return dataImporter.importExercisesUsingData(data)
  }
}
