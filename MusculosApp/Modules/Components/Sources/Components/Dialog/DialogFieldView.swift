//
//  DialogFieldView.swift
//  Components
//
//  Created by Solomon Alexandru on 12.11.2024.
//

import SwiftUI
import Utility

public struct DialogFieldView: View {
  @Binding private var isPresented: Bool
  @State private var fieldValue = ""

  private let title: String
  private let buttonTitle: String
  private let fieldLabel: String?
  private let fieldHint: String?
  private let fieldKeyboardType: UIKeyboardType
  private let onSubmit: (String) -> Void

  public init(
    isPresented: Binding<Bool>,
    title: String,
    fieldLabel: String?,
    fieldHint: String?,
    fieldKeyboardType: UIKeyboardType,
    buttonTitle: String,
    onSubmit: @escaping (String) -> Void)
  {
    _isPresented = isPresented
    self.title = title
    self.fieldLabel = fieldLabel
    self.fieldHint = fieldHint
    self.fieldKeyboardType = fieldKeyboardType
    self.buttonTitle = buttonTitle
    self.onSubmit = onSubmit
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 10.0)
      .foregroundStyle(AppColor.navyBlue.opacity(0.88))
      .shadow(radius: 1.0)
      .frame(width: 350, height: 200)
      .overlay {
        VStack(spacing: 30) {
          Text(title)
            .font(AppFont.poppins(.bold, size: 19))
            .foregroundStyle(.white)

          FormField(
            text: $fieldValue,
            label: fieldLabel,
            labelColor: .white,
            textHint: fieldHint,
            keyboardType: fieldKeyboardType)
            .frame(width: 150)

          Button(action: {
            isPresented = false
            onSubmit(fieldValue)
          }, label: {
            Text(buttonTitle)
              .font(AppFont.poppins(.semibold, size: 14))
              .foregroundStyle(.white)
              .frame(width: 150)
          })
          .buttonStyle(PrimaryButtonStyle())
        }
        .padding(20)
      }
      .dismissingGesture(direction: .down, action: {
        isPresented = false
      })
  }
}

#Preview {
  DialogFieldView(
    isPresented: .constant(true),
    title: "What is your name?",
    fieldLabel: nil,
    fieldHint: nil,
    fieldKeyboardType: .default,
    buttonTitle: "Continue",
    onSubmit: { _ in })
}
