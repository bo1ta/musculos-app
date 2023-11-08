//
//  SearchBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct SearchBarView: View {
  private let placeholderText: String
  private let showFilters: Bool
  private let onFiltersTapped: () -> Void

  @Binding private var searchQuery: String
  @State private var isTextFieldFocused: Bool = false

  init(placeholderText: String,
       searchQuery: Binding<String> = .constant(""),
       showFilters: Bool = false,
       onFiltersTapped: @escaping () -> Void = {}) {
    self.placeholderText = placeholderText
    self.showFilters = showFilters
    self._searchQuery = searchQuery
    self.onFiltersTapped = onFiltersTapped
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 20.0)
      .frame(maxHeight: 50)
      .foregroundColor(.white)
      .opacity(UIConstants.componentOpacity)
      .overlay {
        HStack(spacing: 0) {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
          TextField(placeholderText, text: $searchQuery)
            .font(.callout)
            .padding()
            .textInputAutocapitalization(.never)
          
          if showFilters {
            Image(systemName: "blinds.horizontal.open")
              .foregroundColor(.gray)
              .onTapGesture(perform: self.onFiltersTapped)
          }
        }
        .padding()
      }
  }
}

struct SearchBarView_Preview: PreviewProvider {
  static var previews: some View {
    SearchBarView(placeholderText: "Search workouts")
      .previewLayout(.sizeThatFits)
  }
}
