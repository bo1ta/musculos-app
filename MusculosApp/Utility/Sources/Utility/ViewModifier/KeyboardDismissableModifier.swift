//
//  KeyboardDismissableViewModifier.swift
//  
//
//  Created by Solomon Alexandru on 22.08.2024.
//

import SwiftUI

/// View modifier that hides the keyboard when tapping outside of it
///
public struct KeyboardDismissableViewModifier: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content
      .onTapGesture {
        let keyWindow = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .map({$0 as? UIWindowScene})
          .compactMap({$0})
          .first?.windows
          .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
      }
  }
}
