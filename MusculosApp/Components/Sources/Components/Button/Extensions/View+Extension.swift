//
//  View+Extension.swift
//  Components
//
//  Created by Solomon Alexandru on 21.12.2024.
//

import Shimmer
import SwiftUI

public extension View {
  func defaultShimmering(active: Bool = true) -> some View {
    shimmering(
      active: active,
      gradient: Gradient(
        colors: [
          .white,
          .white.opacity(0.8),
        ]
      )
    )
  }
}

// MARK: - View Modifiers

public extension View {
  func withKeyboardDismissingOnTap() -> some View {
    modifier(KeyboardDismissableViewModifier())
  }

  func animatedScreenBorder(isActive: Bool) -> some View {
    modifier(AnimatedScreenBordersModifier(isActive: isActive))
  }

  func toastView(toast: Binding<Toast?>) -> some View {
    modifier(ToastViewModifier(toast: toast))
  }
}

// MARK: - Dismiss Gesture

public extension View {
  func dismissingGesture(tolerance: Double = 24, direction: DragGesture.Value.Direction, action: @MainActor @escaping () -> Void) -> some View {
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

public extension DragGesture.Value {
  func detectDirection(_ tolerance: Double = 24) -> Direction? {
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

  enum Direction {
    case left
    case right
    case up // swiftlint:disable:this identifier_name
    case down
  }
}
