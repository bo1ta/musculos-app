//
//  HapticFeedbackProvider.swift
//  
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import SwiftUI
import UIKit

private let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
private let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
private let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

public enum HapticFeedbackStyle {
  case lightImpact
  case mediumImpact
  case heavyImpact
  case selection
  case notifySuccess
  case notifyWarning
  case notifyError
}

public struct HapticFeedbackProvider {
  public static func hapticFeedback(_ style: HapticFeedbackStyle) {
    DispatchQueue.main.async {
      switch style {
      case .lightImpact:
        lightImpactFeedbackGenerator.impactOccurred()
      case .mediumImpact:
        mediumImpactFeedbackGenerator.impactOccurred()
      case .heavyImpact:
        heavyImpactFeedbackGenerator.impactOccurred()
      case .selection:
        selectionFeedbackGenerator.selectionChanged()
      case .notifySuccess:
        notificationFeedbackGenerator.notificationOccurred(.success)
      case .notifyWarning:
        notificationFeedbackGenerator.notificationOccurred(.warning)
      case .notifyError:
        notificationFeedbackGenerator.notificationOccurred(.error)
      }
    }
  }
}
