//
//  FormField.swift
//  
//
//  Created by Solomon Alexandru on 28.07.2024.
//

import SwiftUI
import Utility

public struct FormField: View {
  private let text: Binding<String>
  private let hint: String
  private let hintColor: Color
  private let keyboardType: UIKeyboardType
  private let isSecureField: Bool

  public init(
    text: Binding<String>,
    hint: String,
    hintColor: Color = .black,
    keyboardType: UIKeyboardType = .default,
    isSecureField: Bool = false
  ) {
    self.text = text
    self.hint = hint
    self.hintColor = hintColor
    self.keyboardType = keyboardType
    self.isSecureField = isSecureField
  }

  public var body: some View {
    VStack(alignment: .leading) {
      textHint

      gradientRectangle
        .overlay { field }
        .shadow(radius: 0.3)
    }
  }

  private var gradientRectangle: some View {
    RoundedRectangle(cornerRadius: 18)
      .fill(LinearGradient(
        gradient: Gradient(colors: [Color.white, Color.white.opacity(0.9)]),
        startPoint: .top,
        endPoint: .bottom
      ))
      .shadow(color: .gray.opacity(0.3), radius: 3)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
  }

  private var textHint: some View {
    Text(hint)
      .font(AppFont.poppins(.regular, size: 20))
      .foregroundStyle(hintColor)
  }

  private var field: some View {
    Group {
      if isSecureField {
        SecureField(text: text, label: { })
      } else {
        TextField(text: text, label: { })
      }
    }
    .foregroundStyle(.black)
    .textInputAutocapitalization(.never)
    .autocorrectionDisabled()
    .keyboardType(keyboardType)
    .padding(.leading)
  }
}

#Preview {
  FormField(text: .constant(""), hint: "Username", hintColor: .indigo, keyboardType: .decimalPad)
}
