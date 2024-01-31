//
//  CustomTextFieldView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.10.2023.
//

import SwiftUI

struct CustomTextFieldView: View {
  var text: Binding<String> = .constant("")
  var textHint: String
  var systemImageName: String?
  var isSecureField: Bool

  init(text: Binding<String>, textHint: String = "", systemImageName: String? = nil, isSecureField: Bool = false) {
    self.text = text
    self.textHint = textHint
    self.systemImageName = systemImageName
    self.isSecureField = isSecureField
  }

  var body: some View {
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
      } else {
        TextField(textHint, text: text)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      }
    }
    .padding()
    .background(Capsule().fill(.white).shadow(radius: 2))
  }
}

struct CustomTextFieldViewPreview: PreviewProvider {
  static var previews: some View {
    CustomTextFieldView(text: Binding<String>.constant(""), textHint: "Name")
      .previewLayout(.sizeThatFits)
  }
}
