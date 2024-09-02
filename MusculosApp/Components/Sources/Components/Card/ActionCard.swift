//
//  ActionCard.swift
//
//
//  Created by Solomon Alexandru on 26.08.2024.
//

import SwiftUI
import Utility

public struct ActionCard: View {
  let actionIcon: Image
  let actionTitle: String
  let actionDescription: String?
  let backgroundColor: Color
  let onActionButton: () -> Void

  public init(
    actionIcon: Image,
    actionTitle: String,
    actionDescription: String? = nil,
    backgroundColor: Color = AppColor.lightBlue,
    onActionButton: @escaping () -> Void
  ) {
    self.actionIcon = actionIcon
    self.actionTitle = actionTitle
    self.actionDescription = actionDescription
    self.backgroundColor = backgroundColor
    self.onActionButton = onActionButton
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 28)
      .frame(maxWidth: .infinity)
      .frame(width: 350, height: 100)
      .shadow(radius: 0.8)
      .foregroundStyle(backgroundColor)
      .overlay {
        HStack(spacing: 15) {
          actionIconView
          actionText
          Spacer()
          actionButton
        }
        .padding(.horizontal, 25)
      }
  }

  private var actionIconView: some View {
    Circle()
      .frame(height: UIConstant.mediumIconSize + 15.0)
      .foregroundStyle(.black)
      .shadow(radius: 0.6)
      .overlay {
        actionIcon
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(.white)
          .frame(width: UIConstant.smallIconSize)
      }
  }

  private var actionText: some View {
    VStack(alignment: .leading, spacing: 5) {
      if let actionDescription {
        Text(actionDescription)
          .font(AppFont.poppins(.regular, size: 10))
      }

      Text(actionTitle)
        .font(AppFont.poppins(.bold, size: 20))
    }
    .foregroundStyle(.black)
    .opacity(0.5)
  }

  private var actionButton: some View {
    Button(action: onActionButton, label: {
      RoundedRectangle(cornerRadius: 12)
        .foregroundStyle(.white)
        .frame(width: 40, height: 40)
        .overlay {
          Image("fire-icon")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(height: UIConstant.largeIconSize)
            .foregroundStyle(.black)
            .opacity(0.95)
        }
    })
  }
}

#Preview {
  ActionCard(actionIcon: Image(systemName: "heart"), actionTitle: "4000 Steps", actionDescription: "New Challenge! 🔥", onActionButton: {})
}
