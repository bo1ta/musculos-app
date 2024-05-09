//
//  CardItem.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI
import Shimmer

struct CardItem: View {
  let title: String
  let isSelected: Bool
  let onSelect: () -> Void
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
      .overlay {
        Button(action: onSelect, label: {
          HStack {
            Text(title)
              .font(.body(.regular, size: 13))
              .foregroundStyle(Color.AppColor.blue800)
            Spacer()
            
            Circle()
              .frame(width: 20, height: 20)
              .foregroundStyle(isSelected ? Color.AppColor.blue500 : .white)
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .stroke(.gray, lineWidth: 1)
              )
          }
          .padding([.leading, .trailing], 20)
        })
      }
  }
}

#Preview {
  CardItem(title: "100 miles running", isSelected: true, onSelect: {})
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
