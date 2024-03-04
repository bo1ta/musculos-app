//
//  StatsCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct StatsCard: View {
  let weight: Int
  let height: Int
  let growth: Int
  
    var body: some View {
      RoundedRectangle(cornerRadius: 20)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding([.leading, .trailing], 20)
        .foregroundStyle(.white)
        .shadow(radius: 1.5)
        .overlay {
          HStack {
            StatsItem(title: "Weight", description: String(weight))
            Divider()
              .padding([.leading, .trailing], 20)
            StatsItem(title: "Height", description: String(height))
            Divider()
              .padding([.leading, .trailing], 20)
            StatsItem(title: "Growth", description: String(growth))
          }
          .padding()
        }
    }
}

#Preview {
  StatsCard(weight: 80, height: 180, growth: 100)
}
