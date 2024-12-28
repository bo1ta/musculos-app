//
//  RegexValidator.swift
//
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import Foundation

private let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
private let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
private let usernameRegex = "^[A-Za-z0-9_]{3,}$"

public enum RegexValidator {
  public static func isValidEmail(_ email: String) -> Bool {
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
  }

  public static func isValidPassword(_ password: String) -> Bool {
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
  }

  public static func isValidUsername(_ username: String) -> Bool {
    let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
    return usernamePredicate.evaluate(with: username)
  }
}
