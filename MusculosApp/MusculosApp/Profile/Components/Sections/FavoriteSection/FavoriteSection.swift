//
//  FavoriteSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct FavoriteSection: View {
    var body: some View {
      VStack(alignment: .leading) {
        Text("Most repeated exercises")
          .font(.custom(AppFont.medium, size: 18))
        FavoriteSectionItem(title: "100 miles running", value: 10)
      }
      .padding([.leading, .trailing], 20)
    }
}

#Preview {
    FavoriteSection()
}
