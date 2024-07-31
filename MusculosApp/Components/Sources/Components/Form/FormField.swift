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
  private let keyboardType: UIKeyboardType
  private let isSecureField: Bool

  public init(
    text: Binding<String>,
    hint: String,
    keyboardType: UIKeyboardType = .default,
    isSecureField: Bool = false
  ) {
    self.text = text
    self.hint = hint
    self.keyboardType = keyboardType
    self.isSecureField = isSecureField
  }

  public var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundStyle(.white)
        .shadow(radius: 1.2)
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 1)
            .foregroundStyle(Color.gray.opacity(0.7))
        }
        .overlay { field }
        .shadow(radius: 0.3)
    }
  }

  private var textHint: some View {
    Text(hint)
      .font(Font.body(.light, size: 15))
      .foregroundStyle(.gray.opacity(0.9))
  }

  @ViewBuilder
  private var field: some View {
    Group {
      if isSecureField {
        SecureField(text: text, label: { textHint })
      } else {
        TextField(text: text, label: { textHint })
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
  FormField(text: .constant(""), hint: "Username", keyboardType: .decimalPad)
}
