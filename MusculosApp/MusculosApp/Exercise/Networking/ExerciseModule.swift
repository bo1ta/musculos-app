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
  func searchFor(query: String) async throws -> [Exercise]
}

struct ExerciseModule: ExerciseModuleProtocol, SupabaseModule {
  func getExercises() async throws -> [Exercise] {
    return try await supabaseDatabase.rpc("get_exercises").execute().value
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

    return try await query
      .execute()
      .value
  }
  
  func searchFor(query: String) async throws -> [Exercise] {
    return try await supabaseDatabase
      .from(SupabaseConstants.Table.exercises.rawValue)
      .select()
      .textSearch("name", query: query, config: nil, type: .none)
      .limit(10)
      .execute()
      .value
  }
  
  private func createFilterQueryString(_ list: [String]) -> URLQueryRepresentable {
    return StringListQueryRepresentable(list: list)
  }
}
