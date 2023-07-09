//
//  HorizontalSelectPill.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct HorizontalSelectPill: View {
    private let title: String
    private let options: [String]
    
    @Binding private var selectedOption: String
    
    init(title: String, options: [String], selectedOption: Binding<String> = .constant("")) {
        self.title = title
        self.options = options
        self._selectedOption = selectedOption
    }
    
    var body: some View {
        TransparentContainer {
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                
                buttonStack
                Spacer()
            }
        }
    }
    
    @ViewBuilder private var buttonStack: some View {
        HStack(spacing: 20) {
            ForEach(self.options, id: \.self) { option in
                Button(action: {
                    self.selectedOption = option
                }, label: {
                    Text(option)
                        .frame(maxWidth: 120)
                })
                .buttonStyle(SelectedButton(isSelected: selectedOption == option))
            }
        }
    }
}

struct HorizontalSelectPill_Preview: PreviewProvider {
    static var previews: some View {
        HorizontalSelectPill(title: "Location", options: ["Home", "Gym", "Mix"])
    }
}
