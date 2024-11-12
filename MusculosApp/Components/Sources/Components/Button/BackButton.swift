//
//  BackButton.swift
//  Components
//
//  Created by Solomon Alexandru on 12.11.2024.
//

import SwiftUI

public struct BackButton: View {
  let onPress: () -> Void

  public init(onPress: @escaping () -> Void) {
    self.onPress = onPress
  }

  public var body: some View {
    Button(action: onPress, label: {
      Image(systemName: "chevron.left")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 20)
        .foregroundStyle(.white)
        .bold()
    })
  }
}
