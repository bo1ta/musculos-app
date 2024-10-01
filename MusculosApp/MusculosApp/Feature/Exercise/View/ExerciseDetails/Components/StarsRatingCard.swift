//
//  StarsRatingCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI
import Utility

struct StarsRatingCard: View {
  let stars: Double
  var body: some View {
    RoundedRectangle(cornerRadius: 18)
      .foregroundStyle(.white)
      .shadow(radius: 1)
      .frame(maxWidth: .infinity)
      .frame(height: 70)
      .overlay {
        HStack {
          VStack(alignment: .leading, spacing: 2) {
            Text("Rating")
              .shadow(radius: 0.2)
              .font(AppFont.poppins(.regular, size: 16))
              .foregroundStyle(.gray)

            HStack {
              ForEach(1...5, id: \.self) { index in
                if index <= Int(stars) {
                  Image("star-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                } else {
                  Image("star-icon-empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                }
              }

              Text(String(stars))
                .foregroundStyle(.yellow)
                .font(AppFont.poppins(.bold, size: 15))
                .fixedSize(horizontal: true, vertical: false)
            }
          }

          Spacer()
        }
        .padding(.horizontal)
      }
  }
}

#Preview {
  StarsRatingCard(stars: 4)
}
