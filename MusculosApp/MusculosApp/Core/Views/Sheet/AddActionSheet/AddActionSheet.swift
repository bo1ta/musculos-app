//
//  AddActionSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.03.2024.
//

import Foundation
import SwiftUI
import Components
import Utility

struct AddActionSheet: View {
  @Environment(\.dismiss) private var dismiss

  let onItemTapped: (ItemType) -> Void

  var cardGradient = LinearGradient(colors: [.blue], startPoint: .top, endPoint: .bottom)

  var body: some View {
    VStack {
      Text("Create new")
        .font(AppFont.poppins(.bold, size: 15.0))
        .foregroundStyle(.black)

      ForEach(ItemType.allCases, id: \.self) { itemType in
        Button(
          action: { onItemTapped(itemType) },
          label: {
            RoundedRectangle(cornerRadius: 12)
              .foregroundStyle(itemType.cardColor)
              .frame(maxWidth: .infinity)
              .frame(height: 40)
              .padding(.horizontal, 40)
              .overlay {
                HStack {
                  Image(systemName: itemType.systemImageName)
                    .foregroundStyle(.white)
                  Text(itemType.title)
                    .foregroundStyle(.white)
                    .font(AppFont.poppins(.semibold, size: 14))
                    .shadow(radius: 1.0)
                  Spacer()
                }
                .padding(.leading, 60)
              }
          })
      }
    }
  }
}

extension AddActionSheet {
  enum ItemType: String, CaseIterable {
    case workout, exercise, goal

    var title: String { self.rawValue.capitalized }

    var systemImageName: String {
      switch self {
      case .workout: "list.dash.header.rectangle"
      case .exercise: "dumbbell.fill"
      case .goal: "star"
      }
    }

    var cardColor: Color {
      switch self {
      case .workout: Color.orange
      case .exercise: AppColor.navyBlue
      case .goal: Color.yellow
      }
    }
  }
}

#Preview {
  AddActionSheet { _ in }
}
