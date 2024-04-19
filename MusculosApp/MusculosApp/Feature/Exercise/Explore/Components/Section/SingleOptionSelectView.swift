//
//  SingleOptionSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI

struct SingleOptionSelectView: View {
  @Binding var showOptions: Bool
  @Binding var selectedOption: String
  
  var title: String
  var options: [String]
  
  var body: some View {
    VStack {
      
      Button {
        showOptions.toggle()
      } label: {
        HStack {
          Text(title)
            .font(.header(.bold, size: 18))
            .frame(maxWidth: .infinity)
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
            .buttonStyle(SelectedButton(isSelected: selectedOption.contains(filter)))
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
  MultiOptionsSelectView(showOptions: .constant(true), selectedOptions: .constant([]), title: "Muscles", options: ["Chest", "Back", "Legs"])
}

