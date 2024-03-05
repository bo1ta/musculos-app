//
//  UserProfileFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.02.2024.
//

import Foundation

struct UserProfileFactory: UserProfileProvider {
  var gender: String?
  var fullName: String?
  var username: String?
  var email: String?
  var weight: NSNumber?
  var height: NSNumber?
  var isCurrentUser: Bool
  var synchronized: NSNumber
  var updatedAt: Date
  
  static func build(fullName: String = "John Doe",
                    username: String = "john.doe2000",
                    weight: NSNumber = NSNumber(integerLiteral: 80),
                    height: NSNumber = NSNumber(integerLiteral: 80),
                    isCurrentUser: Bool = true,
                    synchronized: NSNumber = NSNumber(integerLiteral: 1),
                    updatedAt: Date = Date.now) -> UserProfileProvider {
    return self.init(fullName: fullName,
                     username: username,
                     weight: weight,
                     height: height,
                     isCurrentUser: isCurrentUser,
                     synchronized: synchronized,
                     updatedAt: updatedAt)
  }
}
