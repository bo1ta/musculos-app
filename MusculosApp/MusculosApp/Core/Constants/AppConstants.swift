//
//  AppConstants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.01.2024.
//

import Foundation

struct AppConstants {
  private enum SupabaseKeys {
    static let appUrl = "SUPABASE_APP_URL"
    static let appKey = "SUPABASE_APP_KEY"
  }
  
  static let supabaseAppUrl: URL = {
    guard
      let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: SupabaseKeys.appUrl) as? String,
      let url = URL(string: "https://" + baseURLProperty)
    else {
      fatalError("SUPABASE_APP_URL not found")
    }
    return url
  }()
  
  static let supabaseAppKey: String = {
    guard let appKeyProperty = Bundle.main.object(forInfoDictionaryKey: SupabaseKeys.appKey) as? String else {
      fatalError("SUPABASE_APP_KEY not found")
    }
    return appKeyProperty
  }()
}
