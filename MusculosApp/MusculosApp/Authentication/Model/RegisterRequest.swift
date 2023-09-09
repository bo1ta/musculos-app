//
//  RegisterRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation

struct User: Codable {
    var userName: String
    var id: Int
    var email: String
}

struct RegisterResponse: Codable, DecodableModel {
    var user: User
    var token: String
}
