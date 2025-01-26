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
  private let label: String?
  private let labelColor: Color
  private let textHint: String?
  private let keyboardType: UIKeyboardType
  private let isSecureField: Bool
  private let imageIcon: Image?

  public init(
    text: Binding<String>,
    label: String? = nil,
    labelColor: Color = .black,
    textHint: String? = nil,
    keyboardType: UIKeyboardType = .default,
    isSecureField: Bool = false,
    imageIcon: Image? = nil)
  {
    self.text = text
    self.label = label
    self.labelColor = labelColor
    self.textHint = textHint
    self.keyboardType = keyboardType
    self.isSecureField = isSecureField
    self.imageIcon = imageIcon
  }

  public var body: some View {
    VStack(alignment: .leading) {
      if let label {
        Text(label)
          .font(AppFont.poppins(.medium, size: 15))
          .foregroundStyle(labelColor)
      }

      RoundedRectangle(cornerRadius: 18)
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.white.opacity(0.9)]),
            startPoint: .top,
            endPoint: .bottom))
        .shadow(color: .gray.opacity(0.3), radius: 3)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .overlay {
          HStack {
            if let imageIcon {
              imageIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            }

            if isSecureField {
              SecureField(text: text, label: {
                if let textHint {
                  Text(textHint)
                }
              })
              .textContentType(.none)
            } else {
              TextField(text: text, label: {
                if let textHint {
                  Text(textHint)
                }
              })
            }
          }
          .textContentType(.none)
          .foregroundStyle(.black)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .keyboardType(keyboardType)
          .padding(.leading)
        }
        .shadow(radius: 0.3)
    }
  }
}

#Preview {
  FormField(
    text: .constant(""),
    label: "Username",
    labelColor: .indigo,
    keyboardType: .decimalPad,
    imageIcon: Image("search-icon"))
}
