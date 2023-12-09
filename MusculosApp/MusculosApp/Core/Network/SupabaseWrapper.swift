//
//  SupabaseWrapper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.12.2023.
//

import Foundation
import Supabase

final class SupabaseWrapper {
  private let supabaseAppUrl = "https://wqgqgfospzhwoqeqdzbo.supabase.co"
  private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxZ3FnZm9zcHpod29xZXFkemJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE1NTk4MTcsImV4cCI6MjAxNzEzNTgxN30.91uci4-y4VIprNFXfLoK3RAJZWr1mQqp0gW81eSxwIM"
  
  static let shared = SupabaseWrapper()
  
  let client: SupabaseClient
  
  var database: PostgrestClient {
    return client.database
  }
  
  var auth: GoTrueClient {
    return client.auth
  }

  init() {
    self.client = SupabaseClient(supabaseURL: URL(string: supabaseAppUrl)!, supabaseKey: supabaseKey)
  }
}
