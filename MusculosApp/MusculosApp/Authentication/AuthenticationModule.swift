//
//  AuthenticationModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine

public class AuthenticationModule {
    var client: MusculosClient
    
    init(client: MusculosClient = MusculosClient()) {
        self.client = client
    }
    
    
    func registerUser(username: String, email: String, password: String) async throws -> RegisterResponse {
        var request = APIRequest(method: .post, path: .register)
        request.body = ["user_name": username, "email": email, "password": password]
        
        let responseData = try await self.client.dispatch(request)
        return try await RegisterResponse.createFrom(responseData)
    }
    
    func loginUser(email: String, password: String) async throws -> LoginResponse {
        var request = APIRequest(method: .post, path: .authentication)
        request.body = ["email": email, "password": password]
        
        let responseData = try await self.client.dispatch(request)
        return try await LoginResponse.createFrom(responseData)
    }
}
