//
//  ExploreSearchSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.11.2024.
//

import Components
import SwiftUI
import Utility

struct ExploreSearchSection: View {
  let onFiltersTap: () -> Void
  let onSearchQuery: (String) -> Void

  @StateObject private var debouncedQueryObserver = DebouncedQueryObserver()

  var body: some View {
    HStack {
      FormField(text: $debouncedQueryObserver.searchQuery, textHint: "Search by muscle", imageIcon: Image("search-icon"))
      Button(action: onFiltersTap, label: {
        Image(systemName: "line.3.horizontal.decrease")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(height: 15)
          .foregroundStyle(.black.opacity(0.9))
      })
      .buttonStyle(.plain)
      .padding(.horizontal, 5)
    }
    .onChange(of: debouncedQueryObserver.debouncedQuery) { _, newQuery in
      if newQuery.count > 3 {
        onSearchQuery(newQuery)
      }
    }
  }
}
