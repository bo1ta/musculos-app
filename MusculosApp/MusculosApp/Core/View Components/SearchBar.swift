//
//  SearchBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct SearchBar: View {
    private let placeholderText: String
    private let onFiltersTapped: () -> Void
    
    @Binding private var searchQuery: String
    @State private var isTextFieldFocused: Bool = false
    
    init(placeholderText: String, searchQuery: Binding<String> = .constant(""),
         onFiltersTapped: @escaping () -> Void = {}) {
        self.placeholderText = placeholderText
        self._searchQuery = searchQuery
        self.onFiltersTapped = onFiltersTapped
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .frame(maxHeight: 50)
            .foregroundColor(.white)
            .opacity(0.5)
            .overlay {
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField(placeholderText, text: $searchQuery)
                        .font(.callout)
                        .padding()
                    Image(systemName: "blinds.horizontal.open")
                        .foregroundColor(.gray)
                        .onTapGesture(perform: self.onFiltersTapped)
                }
                .padding()
            }
            .padding(4)
    }
}

struct SearchBar_Preview: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholderText: "Search workouts")
            .previewLayout(.sizeThatFits)
    }
}
