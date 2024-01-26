//
//  AuthenticationModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine
import Supabase

protocol AuthenticationModuleProtocol {
  func registerUser(email: String, password: String, extraData: [String: AnyJSON]?) async -> Result<Void, MusculosError>
  func loginUser(email: String, password: String) async -> Result<Void, MusculosError>
}

public class AuthenticationModule: AuthenticationModuleProtocol {
  func registerUser(email: String, password: String, extraData: [String: AnyJSON]? = nil) async -> Result<Void, MusculosError> {
    do {
      let response = try await SupabaseWrapper.shared.auth.signUp(email: email, password: password, data: extraData)
      if response.session != nil {
        return .success(())
      } else {
        return .failure(MusculosError.notFound)
      }
    } catch {
      return .failure(MusculosError.sdkError(error))
    }
  }
  
  func loginUser(email: String, password: String) async -> Result<Void, MusculosError> {
    do {
      try await SupabaseWrapper.shared.auth.signIn(email: email, password: password)
      MusculosLogger.logInfo(message: "Login successfull", category: .networking)
      return .success(())
    } catch {
      MusculosLogger.logError(error: error, message: "Could not login user", category: .networking)
      return .failure(MusculosError.sdkError(error))
    }
  }
}
