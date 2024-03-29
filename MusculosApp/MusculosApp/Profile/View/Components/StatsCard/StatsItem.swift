//
//  StatsItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct StatsItem: View {
  let title: String
  let description: String
  
    var body: some View {
        VStack {
          Text(title)
            .font(.header(.bold, size: 14))
            .foregroundStyle(.black)
          Text(description)
            .font(.body(.regular, size: 14))
            .foregroundStyle(.gray)
        }
      }
}

#Preview {
  StatsItem(title: "Hello", description: "Some description")
}
