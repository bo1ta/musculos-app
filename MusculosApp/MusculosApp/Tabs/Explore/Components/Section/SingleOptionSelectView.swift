//
//  SingleOptionSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import Components
import SwiftUI
import Utility

struct SingleOptionSelectView: View {
  @Binding var showOptions: Bool
  @Binding var selectedOption: String

  var title: String
  var options: [String]

  let columns = [
    GridItem(.adaptive(minimum: 100)),
  ]

  var body: some View {
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
