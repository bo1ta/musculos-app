//
//  SelectTextResizablePillsStack.swift
//  Components
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI
import Utility

public struct SelectTextResizablePillsStack: View {
  let options: [String]
  @Binding var selectedOption: String?

  public init(options: [String], selectedOption: Binding<String?>) {
    self.options = options
    self._selectedOption = selectedOption
  }

  public var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 15) {
        ForEach(Array(options), id: \.self) { option in
          Button(action: {
            selectedOption = selectedOption == option ? nil : option
          }, label: {
            TextResizablePill(title: option, isSelected: selectedOption == option)
          })
          .buttonStyle(.plain)
        }
      }
    }
  }
}
