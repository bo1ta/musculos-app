//
//  SearchBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding private var searchQuery: String
    
    init(searchQuery: Binding<String> = .constant("")) {
        self._searchQuery = searchQuery
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .frame(maxHeight: 50)
            .foregroundColor(.gray)
            .opacity(0.5)
            .overlay {
                TextField("Search your interest", text: $searchQuery)
                    .padding()
            }
            .padding(4)
    }
}

struct SearchBar_Preview: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
