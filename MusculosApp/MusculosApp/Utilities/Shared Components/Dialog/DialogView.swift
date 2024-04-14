//
//  DialogView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation
import SwiftUI

struct DialogView: View {
  @Environment(\.dismiss) var dismiss
  
  let title: String
  let description: String?
  let buttonTitle: String
  let onButtonTap: (() -> Void)?
  
  init(
    title: String,
    description: String? = nil,
    buttonTitle: String = "Continue",
    onButtonTap: (() -> Void)? = nil
  ) {
    self.title = title
    self.description = description
    self.buttonTitle = buttonTitle
    self.onButtonTap = onButtonTap
  }
  
  var body: some View {
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
              .padding([.leading, .trailing], 60)
          }
          
          Spacer()
          
          Button {
            if let onButtonTap {
              onButtonTap()
            }
            dismiss()
          } label: {
            Text(buttonTitle)
              .font(.body(.regular))
              .foregroundStyle(.white)
              .frame(maxWidth: 200)
          }
          .buttonStyle(PrimaryButton())
          .padding(.bottom, 20)
        }
      }
  }
}

#Preview {
  DialogView(title: "Something occured", description: "Extra long description with more description")
}
