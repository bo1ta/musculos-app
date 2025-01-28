//
//  TitleSelectCard.swift
//  Components
//
//  Created by Solomon Alexandru on 28.01.2025.
//

import Shimmer
import SwiftUI

// MARK: - TitleSelectCard

public struct SelectTitleCard: View {
  let title: String
  let isSelected: Bool
  let onSelect: () -> Void

  public init(title: String, isSelected: Bool, onSelect: @escaping () -> Void) {
    self.title = title
    self.isSelected = isSelected
    self.onSelect = onSelect
  }

  public var body: some View {
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
                  .stroke(.gray, lineWidth: 1))
          }
          .padding(.horizontal, 20)
        })
      }
  }
}

#Preview {
  SelectTitleCard(title: "100 miles running", isSelected: true, onSelect: { })
}

// MARK: - SelectTitleCardShimmering

public struct SelectTitleCardShimmering: View {
  public var body: some View {
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
        .padding(.horizontal, 20)
      }
      .shimmering()
  }
}
