//
//  AuthenticationModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

struct AuthenticationResult: Codable, DecodableModel {
  var token: String
}

protocol UserModuleProtocol {
  func registerUser(email: String, password: String, username: String, fullName: String?) async throws-> AuthenticationResult
  func loginUser(email: String, password: String) async throws -> AuthenticationResult
}

public class UserModule: MusculosModuleProtocol, UserModuleProtocol {
  var client: MusculosClientProtocol
  
  init(client: MusculosClientProtocol = MusculosClient()) {
    self.client = client
  }
  
  func registerUser(email: String, password: String, username: String, fullName: String? = nil) async throws -> AuthenticationResult {
    var body = ["email": email, "password": password, "username": username]
    if let fullName {
      body["fullName"] = fullName
    }
    
    let request = APIRequest(method: .post, path: .register, body: body)
    let data = try await client.dispatch(request)
    return try AuthenticationResult.createFrom(data)
  }
  
  func loginUser(email: String, password: String) async throws -> AuthenticationResult {
    let body = ["email": email, "password": password]
    let request = APIRequest(method: .post, path: .login, body: body)
    let data = try await client.dispatch(request)
    return try AuthenticationResult.createFrom(data)
  }
}
