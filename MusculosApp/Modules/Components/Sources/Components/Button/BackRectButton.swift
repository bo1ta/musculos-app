//
//  BackRectButton.swift
//  Components
//
//  Created by Solomon Alexandru on 27.01.2025.
//

import SwiftUI

public struct BackRectButton: View {
  let onBack: () -> Void

  public init(onBack: @escaping () -> Void) {
    self.onBack = onBack
  }

  public var body: some View {
    Button(action: onBack, label: {
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(.white)
        .frame(width: 30, height: 30)
        .shadow(radius: 1.2)
        .overlay {
          Image(systemName: "chevron.left")
            .foregroundStyle(.black)
        }
    })
  }
}

#Preview {
  BackRectButton(onBack: { })
}
