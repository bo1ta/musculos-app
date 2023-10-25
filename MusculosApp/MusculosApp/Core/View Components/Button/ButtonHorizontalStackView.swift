//
//  ButtonHorizontalStackView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.07.2023.
//

import SwiftUI

struct ButtonHorizontalStackView: View {
  @Binding private var selectedOption: String
  private let options: [String]
  private var buttonsHaveEqualWidth: Bool

  init(selectedOption: Binding<String>, options: [String], buttonsHaveEqualWidth: Bool = true) {
    self._selectedOption = selectedOption
    self.options = options
    self.buttonsHaveEqualWidth = buttonsHaveEqualWidth
  }

  var body: some View {
    if buttonsHaveEqualWidth {
      EqualWidthHStack {
        buttonStack
      }
    } else {
      HStack {
        buttonStack
      }
    }
  }

  private func shouldUseSmallFont(for text: String) -> Bool {
    return !self.buttonsHaveEqualWidth && text.count > 8
  }

  @ViewBuilder
  private var buttonStack: some View {
    ForEach(options, id: \.self) { option in
      Button(action: {
        self.selectedOption = self.selectedOption == option ? "" : option
      }, label: {
        Text(option)
          .font(shouldUseSmallFont(for: option) ? .caption : .body)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(SelectedButton(isSelected: option == selectedOption))
    }
  }
}

struct ButtonHorizontalStackView_Preview: PreviewProvider {
  static var previews: some View {
    ButtonHorizontalStackView(selectedOption: Binding<String>.constant(""), options: ["Mix workout", "Home workout", "Gym workout"])
      .previewLayout(.sizeThatFits)
  }
}
