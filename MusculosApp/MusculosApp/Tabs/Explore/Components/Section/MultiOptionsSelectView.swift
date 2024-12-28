//
//  MultiOptionsSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import SwiftUI
import Utility
import Components

struct MultiOptionsSelectView: View {
  @Binding var showOptions: Bool
  @Binding var selectedOptions: [String]
  
  var title: String
  var options: [String]

  let columns = [
    GridItem(.adaptive(minimum: 100))
  ]

  var body: some View {
    VStack {
      Button {
        withAnimation(.interpolatingSpring(stiffness: 120, damping: 15)) {
          showOptions.toggle()
        }
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
          spacing: 5
        ) {
            ForEach(options, id: \.self) { filter in
              Button {
                handleFilterTap(filter)
              } label: {
                Text(filter)
              }
              .buttonStyle(SelectedButtonStyle(isSelected: selectedOptions.contains(filter)))
            }
          }
        .transition(.opacity.combined(with: .move(edge: .top)))
      }
    }
  }
  
  private func handleFilterTap(_ filter: String) {
    HapticFeedbackProvider.haptic(.selection)

    if let index = selectedOptions.firstIndex(of: filter) {
      selectedOptions.remove(at: index)
    } else {
      selectedOptions.append(filter)
    }
  }
}

#Preview {
  MultiOptionsSelectView(showOptions: .constant(true), selectedOptions: .constant([]), title: "Muscles", options: ["Chest", "Back", "Legs"])
}
