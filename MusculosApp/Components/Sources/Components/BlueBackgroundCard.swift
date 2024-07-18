//
//  BlueBackgroundCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

public struct BlueBackgroundCard: View {
  public var body: some View {
      Rectangle()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .foregroundStyle(Color.AppColor.blue500)
        .shadow(radius: 1)
    }
}

#Preview {
    BlueBackgroundCard()
}
