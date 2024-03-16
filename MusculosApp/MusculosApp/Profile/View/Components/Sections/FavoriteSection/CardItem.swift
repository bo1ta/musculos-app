//
//  CardItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct CardItem: View {
  let title: String
  let value: Int?
  
  init(title: String, value: Int? = nil) {
    self.title = title
    self.value = value
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
      .overlay {
        HStack {
          Text(title)
            .font(.body(.regular, size: 13))
          Spacer()
          
          if let value {
            Text("x\(value)")
              .font(.header(.bold, size: 15))
              .foregroundStyle(Color.AppColor.blue500)
          }
        }
        .padding([.leading, .trailing], 20)
      }
  }
}

#Preview {
  CardItem(title: "100 miles running", value: 10)
}

struct CardItemShimmering: View {
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
      .overlay {
        HStack {
         Rectangle()
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .frame(height: 20)
            .shimmering()
          Spacer()
        }
        .padding([.leading, .trailing], 20)
      }
      .shimmering()
  }
}
