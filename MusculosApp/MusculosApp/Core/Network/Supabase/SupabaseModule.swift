//
//  SupabaseModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import Foundation
import Supabase

protocol SupabaseModule {
  var supabaseStorage: SupabaseStorageClient { get }
  var supabaseDatabase: PostgrestClient { get }
  var supabaseAuth: GoTrueClient { get }
}

extension SupabaseModule {
  var supabaseStorage: SupabaseStorageClient {
    SupabaseWrapper.shared.storage
  }
  
  var supabaseDatabase: PostgrestClient {
    SupabaseWrapper.shared.database
  }
  
  var supabaseAuth: GoTrueClient {
    SupabaseWrapper.shared.auth
  }
}
