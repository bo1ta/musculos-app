//
//  MultiOptionsSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import SwiftUI

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
            .font(.body(.bold, size: 15))
          Spacer()
          Image(systemName: showOptions ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }
      
      if showOptions {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
          ForEach(options, id: \.self) { filter in
            Button {
              handleFilterTap(filter)
            } label: {
              Text(filter)
            }
            .buttonStyle(SelectedButtonStyle(isSelected: selectedOptions.contains(filter)))
          }
        }
      }
    }
  }
  
  private func handleFilterTap(_ filter: String) {
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
