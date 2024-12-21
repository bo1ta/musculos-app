//
//  SmoothTransitionModifier.swift
//  
//
//  Created by Solomon Alexandru on 25.08.2024.
//

import SwiftUI

struct SmoothTransitionModifier: ViewModifier {
  let isPresented: Bool
  let insertion: AnyTransition
  let removal: AnyTransition
  let duration: Double

  func body(content: Content) -> some View {
    content
      .transition(.asymmetric(insertion: insertion, removal: removal))
      .animation(.smooth(duration: duration), value: isPresented)
  }
}

