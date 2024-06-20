//
//  RoundedTextField.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.10.2023.
//

import SwiftUI
import Utilities

struct RoundedTextField: View {
  var text: Binding<String> = .constant("")
  var textHint: String
  var label: String?
  var systemImageName: String?
  var isSecureField: Bool

  init(text: Binding<String>, label: String? = nil, textHint: String = "", systemImageName: String? = nil, isSecureField: Bool = false) {
    self.text = text
    self.textHint = textHint
    self.systemImageName = systemImageName
    self.label = label
    self.isSecureField = isSecureField
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let label {
        Text(label)
          .font(.body(.bold, size: 15))
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
            .font(.body(.light, size: 15))
            .lineLimit(2)
        }
      }
      .background(Capsule().fill(AppColor.blue100).frame(height: 40).shadow(radius: 1.0))
    }
  }
}

struct CustomTextFieldViewPreview: PreviewProvider {
  static var previews: some View {
    RoundedTextField(text: Binding<String>.constant(""), textHint: "Name")
      .previewLayout(.sizeThatFits)
  }
}
