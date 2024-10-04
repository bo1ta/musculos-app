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

  public static func prepareHaptic(_ style: HapticFeedbackStyle) {
    switch style {
    case .lightImpact:
      lightImpactFeedbackGenerator.prepare()
    case .mediumImpact:
      mediumImpactFeedbackGenerator.prepare()
    case .heavyImpact:
      heavyImpactFeedbackGenerator.prepare()
    case .selection:
      selectionFeedbackGenerator.prepare()
    case .notifySuccess:
      notificationFeedbackGenerator.prepare()
    case .notifyWarning:
      notificationFeedbackGenerator.prepare()
    case .notifyError:
      notificationFeedbackGenerator.prepare()
    }
  }
}
