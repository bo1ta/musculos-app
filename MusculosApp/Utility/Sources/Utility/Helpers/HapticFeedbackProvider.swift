//
//  HapticFeedbackProvider.swift
//
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import SwiftUI
import UIKit
import CoreHaptics

@MainActor
public struct HapticFeedbackProvider {
  public enum HapticFeedbackStyle {
    case lightImpact
    case mediumImpact
    case heavyImpact
    case selection
    case notifySuccess
    case notifyWarning
    case notifyError
  }

  private static let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  private static let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
  private static let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
  private static let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
  private static let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

  public static func haptic(_ style: HapticFeedbackStyle) {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    switch style {
    case .lightImpact:
      lightImpactFeedbackGenerator.prepare()
      lightImpactFeedbackGenerator.impactOccurred()
    case .mediumImpact:
      mediumImpactFeedbackGenerator.prepare()
      mediumImpactFeedbackGenerator.impactOccurred()
    case .heavyImpact:
      heavyImpactFeedbackGenerator.prepare()
      heavyImpactFeedbackGenerator.impactOccurred()
    case .selection:
      selectionFeedbackGenerator.prepare()
      selectionFeedbackGenerator.selectionChanged()
    case .notifySuccess:
      notificationFeedbackGenerator.prepare()
      notificationFeedbackGenerator.notificationOccurred(.success)
    case .notifyWarning:
      notificationFeedbackGenerator.prepare()
      notificationFeedbackGenerator.notificationOccurred(.warning)
    case .notifyError:
      notificationFeedbackGenerator.prepare()
      notificationFeedbackGenerator.notificationOccurred(.error)
    }
  }
}
