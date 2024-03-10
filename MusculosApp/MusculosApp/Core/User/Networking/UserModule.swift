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
  func registerUser(email: String, password: String, username: String, fullName: String) async throws -> String
  func loginUser(email: String, password: String) async throws -> String
}

public class UserModule: MusculosModuleProtocol, UserModuleProtocol {
  var client: MusculosClientProtocol
  
  init(client: MusculosClientProtocol = MusculosClient()) {
    self.client = client
  }
  
  func registerUser(email: String, password: String, username: String, fullName: String) async throws -> String {
    var body = [
      "email": email,
      "password": password,
      "username": username
    ]
    if fullName.count > 0 {
      body["fullName"] = fullName
    }
    
    let request = APIRequest(method: .post, path: .register, body: body)
    let data = try await client.dispatch(request)
    
    let result = try AuthenticationResult.createFrom(data)
    return result.token
  }
  
  func loginUser(email: String, password: String) async throws -> String {
    let body = ["email": email, "password": password]
  
    let request = APIRequest(method: .post, path: .login, body: body)
    let data = try await client.dispatch(request)
  
    let result = try AuthenticationResult.createFrom(data)
    return result.token
  }
}
