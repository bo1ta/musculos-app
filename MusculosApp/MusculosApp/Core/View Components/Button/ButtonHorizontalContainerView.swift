//
//  ButtonHorizontalContainerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.08.2023.
//

import SwiftUI

struct SelectListItem {
    var itemTitle: String
    var options: [String]
}

struct ButtonHorizontalContainerView: View {
    @Binding var selectedOption: String
    private let selectListItem: SelectListItem

    init(selectedOption: Binding<String>, selectListItem: SelectListItem) {
        self._selectedOption = selectedOption
        self.selectListItem = selectListItem
    }

    var body: some View {
        TransparentContainerView {
            Text(self.selectListItem.itemTitle)
                .font(.title3)
                .foregroundColor(.white)
                .padding(.bottom, 15)

            ButtonHorizontalStackView(selectedOption: $selectedOption, options: self.selectListItem.options)
        }
    }
}

struct ButtonHorizontalContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonHorizontalContainerView(selectedOption: Binding<String>.constant(""), selectListItem: SelectListItem(itemTitle: "Gym", options: ["Workout"]))
    }
}
