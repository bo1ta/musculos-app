//
//  CustomTextField.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.10.2023.
//

import SwiftUI

struct CustomTextField: View {
  var text: Binding<String> = .constant("")
  var textHint: String
  var label: String?
  var systemImageName: String?
  var isSecureField: Bool
  var keyboardType: UIKeyboardType

  init(text: Binding<String>, label: String? = nil, textHint: String = "", systemImageName: String? = nil, isSecureField: Bool = false, keyboardType: UIKeyboardType = .default) {
    self.text = text
    self.textHint = textHint
    self.systemImageName = systemImageName
    self.label = label
    self.isSecureField = isSecureField
    self.keyboardType = keyboardType
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let label {
        Text(label)
          .font(.body(.bold, size: 14))
          .padding(.bottom, 10)
      }
      HStack {
        if let systemImageName = self.systemImageName {
          Image(systemName: systemImageName)
            .foregroundColor(.secondary)
        } else {
          Spacer(minLength: 10)
        }
        
        if self.isSecureField {
          SecureField(textHint, text: text)
            .textContentType(.password)
            .font(.body(.light, size: 15))
        } else {
          TextField(textHint, text: text, axis: .vertical)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .lineLimit(1)
            .font(.body(.light, size: 13))
            .keyboardType(keyboardType)
        }
      }
      .background(Rectangle().fill(.white).frame(height: 40).shadow(radius: 1.0))
    }
  }
}

struct CustomTextFieldViewPreview: PreviewProvider {
  static var previews: some View {
    CustomTextField(text: Binding<String>.constant(""), textHint: "Name")
      .previewLayout(.sizeThatFits)
  }
}
