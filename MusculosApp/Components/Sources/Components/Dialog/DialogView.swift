//
//  DialogView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation
import SwiftUI

public struct DialogView: View {
  @Environment(\.dismiss) var dismiss
  @Binding var isPresented: Bool

  let title: String
  let description: String?
  let buttonTitle: String

  public init(
    title: String,
    description: String? = nil,
    buttonTitle: String = "Continue",
    isPresented: Binding<Bool>
  ) {
    self.title = title
    self.description = description
    self.buttonTitle = buttonTitle
    _isPresented = isPresented
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 25.0)
      .foregroundStyle(Color.AppColor.blue100)
      .shadow(radius: 1.0)
      .frame(width: 300, height: 150)
      .overlay {
        VStack(spacing: 5) {
          Text(title)
            .font(.header(.bold, size: 14))
            .foregroundStyle(Color.AppColor.blue800)
            .padding(.top, 20)

          if let description {
            Text(description)
              .font(.body(.regular, size: 10))
              .foregroundStyle(.black)
              .padding(.horizontal, 60)
          }

          Spacer()

          Button {
            isPresented = false
          } label: {
            Text(buttonTitle)
              .font(.body(.regular))
              .foregroundStyle(.white)
              .frame(maxWidth: 200)
          }
          .buttonStyle(PrimaryButtonStyle())
          .padding(.bottom, 20)
        }
      }
  }
}

#Preview {
  DialogView(title: "Something occured", description: "Extra long description with more description", isPresented: .constant(true))
}
