//
//  UserProfileProvider.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.02.2024.
//

import Foundation

protocol UserProfileProvider {
  var gender: String? { get set }
  var fullName: String? { get set }
  var username: String? { get set }
  var email: String? { get set }
  var weight: NSNumber? { get set }
  var height: NSNumber? { get set }
  var isCurrentUser: Bool { get set }
  var synchronized: NSNumber { get set }
  var updatedAt: Date { get set }
}
