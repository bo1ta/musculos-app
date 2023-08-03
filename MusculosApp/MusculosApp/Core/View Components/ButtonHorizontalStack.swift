//
//  ButtonHorizontalStack.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.07.2023.
//

import SwiftUI

struct ButtonHorizontalStack: View {
    @Binding private var selectedOption: String
    private let options: [String]
    
    init(selectedOption: Binding<String>, options: [String]) {
        self._selectedOption = selectedOption
        self.options = options
    }
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedOption = self.selectedOption == option ? "" : option
                }, label: {
                    Text(option)
                        .font(.caption)
                        .frame(maxWidth: 110)
                })
                .buttonStyle(SelectedButton(isSelected: option == selectedOption))
            }
        }
    }
}

struct ButtonHorizontalStack_Preview: PreviewProvider {
    static var previews: some View {
        ButtonHorizontalStack(selectedOption: Binding<String>.constant(""), options: ["Mix workout", "Home workout", "Gym workout"])
            .previewLayout(.sizeThatFits)
    }
}
