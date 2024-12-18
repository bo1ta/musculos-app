//
//  View+Extension.swift
//
//
//  Created by Solomon Alexandru on 29.07.2024.
//

import SwiftUI
import Shimmer

public extension View {
  public func defaultShimmering(active: Bool = true) -> some View {
    self.shimmering(
      active: active,
      gradient: Gradient(
        colors: [
          .white,
          .white.opacity(0.8)
        ]
      ))
  }
}
// MARK: - View Modifiers

public extension View {
  public func withKeyboardDismissingOnTap() -> some View {
    self.modifier(KeyboardDismissableViewModifier())
  }

  func animatedScreenBorder(isActive: Bool) -> some View {
    self.modifier(AnimatedScreenBordersModifier(isActive: isActive))
  }
}

// MARK: - Dismiss Gesture

public extension View {
  public func dismissingGesture(tolerance: Double = 24, direction: DragGesture.Value.Direction, action: @MainActor @escaping () -> Void) -> some View {
    gesture(
      DragGesture()
        .onEnded { value in
          let swipeDirection = value.detectDirection(tolerance)
          if swipeDirection == direction {
            action()
          }
        }
    )
  }
}

extension DragGesture.Value {
  public func detectDirection(_ tolerance: Double = 24) -> Direction? {
    if startLocation.x < location.x - tolerance {
      return .left
    }

    if startLocation.x > location.x + tolerance {
      return .right
    }

    if startLocation.y > location.y + tolerance {
      return .up
    }

    if startLocation.y < location.y - tolerance {
      return .down
    }

    return nil
  }

  public enum Direction {
    case left
    case right
    case up
    case down
  }
}
