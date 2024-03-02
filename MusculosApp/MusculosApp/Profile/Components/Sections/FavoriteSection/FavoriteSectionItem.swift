//
//  FavoriteSectionItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct FavoriteSectionItem: View {
  let title: String
  let value: Int
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
      .overlay {
        HStack {
          Circle()
            .frame(width: 30, height: 30)
          Text(title)
            .font(.custom(AppFont.regular, size: 13))
          Spacer()
          Text("x\(value)")
            .font(.custom(AppFont.bold, size: 13))
            .foregroundStyle(Color.appColor(with: .customRed))
        }
        .padding([.leading, .trailing], 20)
      }
  }
}

#Preview {
  FavoriteSectionItem(title: "100 miles running", value: 10)
}
