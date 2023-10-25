//
//  LoginResponse.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation

struct LoginResponse: Codable, DecodableModel {
  var token: String
}
