//
//  XPGainViewModifier.swift
//  Components
//
//  Created by Solomon Alexandru on 21.12.2024.
//

import SwiftUI
import Utility

public struct XPGainViewModifier: ViewModifier {
  let showView: Bool
  let xpGained: Int

  public init(showView: Bool, xpGained: Int) {
    self.showView = showView
    self.xpGained = xpGained
  }

  public func body(content: Content) -> some View {
      content
        .overlay {
          ZStack {
            if showView {
              VStack {
                XPGainView(xpGained)
              }
              .padding()
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
              .transition(.scale(scale: 0.5).combined(with: .move(edge: .trailing)))
              .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: showView)
            }
          }
        }
    }
}

