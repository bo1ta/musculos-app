//
//  AuthenticationModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine
import Supabase

protocol UserModuleProtocol {
  func registerUser(email: String, password: String, extraData: [String: AnyJSON]?) async throws
  func loginUser(email: String, password: String) async throws
}

public class UserModule: UserModuleProtocol {
  func registerUser(email: String, password: String, extraData: [String: AnyJSON]? = nil) async throws {
    try await SupabaseWrapper.shared.auth.signUp(email: email, password: password, data: extraData)
  }
  
  func loginUser(email: String, password: String) async throws {
    try await SupabaseWrapper.shared.auth.signIn(email: email, password: password)
  }
}
