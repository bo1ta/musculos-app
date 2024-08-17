//
//  SelectSizeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import Components
import Utility

struct SelectSizeView: View {
  @Binding var selectedWeight: String
  @Binding var selectedHeight: String

  let onContinue: () -> Void

  var body: some View {
    VStack {
      HStack {
        FormField(
          text: $selectedWeight,
          hint: "Weight",
          keyboardType: .numberPad
        )
        .frame(width: 100)

        Spacer()

        FormField(
          text: $selectedHeight,
          hint: "Height",
          keyboardType: .numberPad
        )
        .frame(width: 100)
      }
      .padding(.bottom, 50)

      Button(action: onContinue, label: {
        Text("Continue")
          .font(AppFont.poppins(.bold, size: 18))
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())

      Image("female-character-question")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 500, height: 500)
    }
    .padding(.horizontal, 50)
  }
}

#Preview {
  SelectSizeView(selectedWeight: .constant("120"), selectedHeight: .constant("120"), onContinue: {})
}
