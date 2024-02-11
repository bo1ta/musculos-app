//
//  DetailCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import SwiftUI

struct DetailCardView: View {
  var title: String
  var index: Int
  
  var body: some View {
    RoundedRectangle(cornerRadius: 5)
      .frame(maxWidth: .infinity)
      .frame(minHeight: 80)
      .padding([.leading, .trailing])
      .foregroundStyle(.white)
      .shadow(radius: 1)
      .overlay {
        HStack {
            Circle()
              .frame(width: 40, height: 40)
              .foregroundStyle(.white)
              .shadow(radius: 1)
              .overlay {
                Text("\(index)")
                  .font(.custom(AppFont.regular, size: 15))
                  .foregroundStyle(.gray)
                  .opacity(0.8)
              }
          Text(title)
            .font(.custom(AppFont.regular, size: 14))
          Spacer()
        }
        .padding(.leading, 35)
      }
  }
}

#Preview {
  DetailCardView(title: "Stand with your feet", index: 1)
    .previewLayout(.sizeThatFits)
}
