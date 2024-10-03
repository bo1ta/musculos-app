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
  
  var body: some View {
    VStack {
      Button {
        showOptions.toggle()
      } label: {
        HStack {
          Text(title)
            .font(AppFont.poppins(.regular, size: 16))
          Spacer()
          Image(systemName: showOptions ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }
      
      if showOptions {
        LazyVGrid(
          columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
          ],
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
        .transition(.push(from: .bottom))
      }
    }
    .animation(.easeInOut(duration: UIConstant.defaultAnimationDuration), value: showOptions)
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
