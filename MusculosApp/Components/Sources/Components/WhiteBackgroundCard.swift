//
//  WhiteBackgroundCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.03.2024.
//

import SwiftUI

/// White `Spacer` with 100 height.
/// Typically used as the last component in a ScrollView for nice spacing.
///
public struct WhiteBackgroundCard: View {
  public init() {}

  public var body: some View {
      Color.white
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
}

#Preview {
    WhiteBackgroundCard()
}
