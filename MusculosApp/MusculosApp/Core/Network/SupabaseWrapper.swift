//
//  SupabaseWrapper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.12.2023.
//

import Foundation
import Supabase

final class SupabaseWrapper {
  private let client: SupabaseClient

  init() {
    self.client = SupabaseClient(supabaseURL: AppConstants.supabaseAppUrl, supabaseKey: AppConstants.supabaseAppKey)
  }
  
  static let shared = SupabaseWrapper()
  
  var database: PostgrestClient {
    client.database
  }
  
  var auth: GoTrueClient {
    client.auth
  }
  
  var storage: SupabaseStorageClient {
    client.storage
  }
  
  func insertData(_ data: Encodable, table: SupabaseConstants.Table) async throws {
    try await database
      .from(table.rawValue)
      .insert(data)
      .execute()
  }
  
  func fetchAll<T: Codable>(table: SupabaseConstants.Table) async throws -> [T] {
    let results: [T] = try await database.from(table.rawValue)
      .select()
      .execute()
      .value
    return results
  }
  
  func fetchById<T: Codable>(id: String, table: SupabaseConstants.Table) async throws -> T? {
    let results: [T] = try await database.from(table.rawValue)
      .select()
      .eq("id", value: id)
      .execute()
      .value
    return results.first
  }
  
  func refreshSession() async {
    do {
      try await auth.refreshSession()
      MusculosLogger.logInfo(message: "did refresh session", category: .supabase)
    } catch {
      MusculosLogger.logError(error: error, message: "Could not refresh session", category: .supabase)
    }
  }
}
