//
//  Untitled.swift
//  Components
//
//  Created by Solomon Alexandru on 19.11.2024.
//

import SwiftUI
import Utility

public struct QuickActionCard: View {
  private let title: String
  private let subtitle: String
  private let onTap: () -> Void

  public init(title: String, subtitle: String, onTap: @escaping () -> Void) {
    self.title = title
    self.subtitle = subtitle
    self.onTap = onTap
  }

  private var gradient: LinearGradient {
    LinearGradient(colors: [Color(hex: "0EA5E9"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
  }

  public var body: some View {
    Button(action: onTap) {
      RoundedRectangle(cornerRadius: 10)
        .foregroundStyle(gradient)
        .frame(maxWidth: .infinity)
        .frame(height: UIConstant.Size.small.cardHeight)
        .shadow(radius: 1.0)
        .overlay {
          HStack {
            Image("barbell-icon")
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .frame(width: UIConstant.Size.large.iconHeight, height: UIConstant.Size.large.iconHeight)
              .foregroundStyle(.white)
              .padding(.leading)

            VStack(alignment: .leading, spacing: 1) {
              Heading(title, fontSize: 16, fontColor: .white)
              Text(subtitle)
                .font(AppFont.poppins(.regular, size: 13))
                .foregroundStyle(.white)
            }

            Spacer()

            Circle()
              .frame(height: 35)
              .padding()
              .foregroundStyle(.white.opacity(0.2))
              .overlay {
                Image(systemName: "chevron.right")
                  .font(.subheadline)
                  .foregroundStyle(.white)
              }
          }
        }
    }
  }
}

#Preview {
  QuickActionCard(title: "Quick sit-ups workout", subtitle: "Working out", onTap: {})
}
