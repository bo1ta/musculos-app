//
//  SingleOptionSelectView.swift
//  Components
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI
import Utility

public struct SingleOptionSelectView: View {
  @Binding var showOptions: Bool
  @Binding var selectedOption: String

  var title: String
  var options: [String]

  public init(showOptions: Binding<Bool>, selectedOption: Binding<String>, title: String, options: [String]) {
    self._showOptions = showOptions
    self._selectedOption = selectedOption
    self.title = title
    self.options = options
  }

  private let columns = [
    GridItem(.adaptive(minimum: 100)),
  ]

  public var body: some View {
    VStack {
      Button {
        showOptions.toggle()
      } label: {
        HStack {
          Text(title)
            .font(AppFont.poppins(.medium, size: 15))
          Spacer()
          Image(systemName: showOptions ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }

      if showOptions {
        LazyVGrid(
          columns: columns,
          spacing: 5)
        {
          ForEach(options, id: \.self) { filter in
            Button {
              handleFilterTap(filter)
            } label: {
              Text(filter)
            }
            .buttonStyle(SelectedButtonStyle(isSelected: selectedOption.contains(filter)))
          }
        }
      }
    }
  }

  private func handleFilterTap(_ filter: String) {
    if selectedOption == filter {
      selectedOption = ""
    } else {
      selectedOption = filter
    }
  }
}

#Preview {
  MultiOptionsSelectView(
    showOptions: .constant(true),
    selectedOptions: .constant([]),
    title: "Muscles",
    options: ["Chest", "Back", "Legs"])
}
