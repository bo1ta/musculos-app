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
    return client.database
  }
  
  var auth: GoTrueClient {
    return client.auth
  }
}
