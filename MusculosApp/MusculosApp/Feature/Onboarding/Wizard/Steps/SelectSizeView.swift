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
      Heading("Select your weight and height")
        .padding([.horizontal, .vertical], 20)
        .padding(.top, 20)

      Spacer()

      Group {
        HStack {
          FormField(
            text: $selectedWeight,
            label: "Weight",
            keyboardType: .numberPad
          )
          .frame(width: 100)

          Spacer()

          FormField(
            text: $selectedHeight,
            label: "Height",
            keyboardType: .numberPad
          )
          .frame(width: 100)
        }
        .padding(.bottom, 50)


        Image("female-character-question")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 330, height: 330)

        Spacer()

        PrimaryButton(title: "Continue", action: onContinue)
      }
      .padding(.horizontal, 50)
    }
  }
}

#Preview {
  SelectSizeView(selectedWeight: .constant("120"), selectedHeight: .constant("120"), onContinue: {})
}
