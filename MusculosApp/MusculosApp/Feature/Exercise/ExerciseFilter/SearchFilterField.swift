//
//  SearchFilterField.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.02.2024.
//

import Foundation
import SwiftUI

struct SearchFilterField: View {
  @StateObject private var debouncedQueryObserver = DebouncedQueryObserver()
  @Binding var showFilterView: Bool
  
  private var hasObservedQuery: (String) -> Void
  
  init(showFilterView: Binding<Bool>, hasObservedQuery: @escaping (String) -> Void) {
    self._showFilterView = showFilterView
    self.hasObservedQuery = hasObservedQuery
  }
  
  var body: some View {
    HStack {
      RoundedTextField(
        text: $debouncedQueryObserver.searchQuery,
        label: "Search",
        textHint: "Search by muscle"
      )
      Button(action: {
        showFilterView = true
      }, label: {
        Circle()
          .frame(width: 35, height: 35)
          .foregroundStyle(Color.AppColor.blue500)
          .overlay {
            Image(systemName: "line.3.horizontal")
              .foregroundStyle(.white)
          }
      })
    }
    .onChange(of: debouncedQueryObserver.debouncedQuery) { query in
      if query.count > 2 {
        hasObservedQuery(query)
      }
    }
    .padding([.leading, .trailing], 10)
  }
}

#Preview {
  SearchFilterField(showFilterView: .constant(false)) { query in
    print(query)
  }
}
