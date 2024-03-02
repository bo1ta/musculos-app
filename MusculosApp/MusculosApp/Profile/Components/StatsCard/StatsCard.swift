//
//  StatsCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct StatsCard: View {
    var body: some View {
      RoundedRectangle(cornerRadius: 20)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding([.leading, .trailing], 20)
        .foregroundStyle(.white)
        .shadow(radius: 1.5)
        .overlay {
          HStack {
            StatsItem(title: "Weight", description: "80")
            Divider()
              .padding([.leading, .trailing], 20)
            StatsItem(title: "Height", description: "180")
            Divider()
              .padding([.leading, .trailing], 20)
            StatsItem(title: "Growth", description: "100")
          }
          .padding()
        }
    }
}

#Preview {
    StatsCard()
}
