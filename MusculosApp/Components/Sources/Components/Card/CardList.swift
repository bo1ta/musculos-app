//
//  CardList.swift
//
//
//  Created by Solomon Alexandru on 26.08.2024.
//

import SwiftUI
import Utility

public struct CardList: View {
  let sectionTitle: String?
  let items: [CardItemType]
  let onItemTap: (CardItemType) -> Void
  let onSectionButtonTap: (() -> Void)?

  public init(sectionTitle: String? = nil, items: [CardItemType], onItemTap: @escaping (CardItemType) -> Void, onSectionButtonTap: (() -> Void)? = nil) {
    self.sectionTitle = sectionTitle
    self.items = items
    self.onItemTap = onItemTap
    self.onSectionButtonTap = onSectionButtonTap
  }

  public var body: some View {
    VStack(alignment: .leading) {
      headerSection
      cardList
    }
  }

  private var cardList: some View {
    ForEach(items, id: \.id) { item in
      makeCardItem(item)
    }
  }

  private var headerSection: some View {
    HStack {
      if let sectionTitle {
        Heading(sectionTitle)
      }

      Spacer()

      if let onSectionButtonTap {
        Button(action: onSectionButtonTap, label: {
          Image(systemName: "chevron.right")
            .font(AppFont.poppins(.regular, size: 20))
            .foregroundStyle(.black)
        })
      }
    }
    .padding()
  }

  @ViewBuilder
  private func makeCardItem(_ item: CardItemType) -> some View {
    let parentCardSize: CGFloat = 100
    let childCardSize: CGFloat = parentCardSize - 25

    RoundedRectangle(cornerRadius: 18)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.white)
      .shadow(radius: 1.2)
      .frame(height: parentCardSize)
      .overlay {
        HStack {
          RoundedRectangle(cornerRadius: 18)
            .foregroundStyle(Color.blue)
            .frame(width: childCardSize, height: childCardSize)
            .overlay {
              Image(item.iconName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.black)
                .frame(height: UIConstant.mediumIconSize)
                .aspectRatio(contentMode: .fit)

            }

          Text(item.title)
            .font(AppFont.poppins(.semibold, size: 18))
            .shadow(radius: 0.6)
            .foregroundStyle(.black)

          Spacer()

          Text(item.description)
            .font(AppFont.poppins(.regular, size: 16))



          if item.isCompleted {
            Image("orange-checkmark-icon")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: UIConstant.mediumIconSize)
          } else {
            Circle()
              .foregroundStyle(.white)
              .shadow(radius: 1.0)
              .frame(height: UIConstant.mediumIconSize)
          }
        }
        .padding()
      }
  }
}



// MARK: - Types

public extension CardList {
  public struct CardItemType: Identifiable {
    public var id: Int
    public var title: String
    public var description: String
    public var isCompleted: Bool
    public var iconName: String
  }
}

#Preview {
  CardList(
    sectionTitle: "Your Workout",
    items: [
      .init(id: 1, title: "Weight Lifting", description: "5 Sets", isCompleted: true, iconName: "dumbbell-icon"),
      .init(id: 2, title: "Rope Skipping", description: "1000", isCompleted: false, iconName: "rope-icon")
    ],
    onItemTap: { print($0) },
    onSectionButtonTap: {}
  )
}
