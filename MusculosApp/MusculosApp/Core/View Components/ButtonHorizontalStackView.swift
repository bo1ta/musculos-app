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
    
    init(selectedOption: Binding<String>, options: [String]) {
        self._selectedOption = selectedOption
        self.options = options
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Spacer()
                Button(action: {
                    self.selectedOption = self.selectedOption == option ? "" : option
                }, label: {
                    Text(option)
                        .font(.body)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: true, vertical: true)
                })
                .buttonStyle(SelectedButton(isSelected: option == selectedOption))
                Spacer()
            }
        }
    }
}

struct ButtonHorizontalStackView_Preview: PreviewProvider {
    static var previews: some View {
        ButtonHorizontalStackView(selectedOption: Binding<String>.constant(""), options: ["Mix workout", "Home workout", "Gym workout"])
            .previewLayout(.sizeThatFits)
    }
}
