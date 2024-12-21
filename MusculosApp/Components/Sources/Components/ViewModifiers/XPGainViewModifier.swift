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
        if showView {
          VStack {
            XPGainView(xpGained)
            Spacer()
          }
          .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: showView)
          .padding(.top, 10)
          .transition(.asymmetric(insertion: .push(from: .top), removal: .move(edge: .top)))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
  }
}

