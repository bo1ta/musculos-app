//
//  FiltersSectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import SwiftUI

struct FiltersSectionView: View {
  @Binding var showFilters: Bool
  @Binding var selectedFilters: [String]
  
  var title: String
  var filters: [String]
  
  var body: some View {
    VStack {
      
      Button {
        showFilters.toggle()
      } label: {
        HStack {
          Text(title)
            .font(.custom(AppFont.bold, size: 18))
          Spacer()
          Image(systemName: showFilters ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }
      
      if showFilters {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
          ForEach(filters, id: \.self) { filter in
            Button {
              if let index = selectedFilters.firstIndex(of: filter) {
                selectedFilters.remove(at: index)
              } else {
                selectedFilters.append(filter)
              }
            } label: {
              Text(filter)
            }
            .buttonStyle(SelectedButton(isSelected: selectedFilters.contains(filter)))
          }
        }
      }
    }
  }
}

#Preview {
  FiltersSectionView(showFilters: .constant(true), selectedFilters: .constant([]), title: "Muscles", filters: ["Chest", "Back", "Legs"])
}
