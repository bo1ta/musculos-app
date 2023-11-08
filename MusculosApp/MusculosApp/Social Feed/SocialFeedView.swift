//
//  SocialFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.11.2023.
//

import SwiftUI

struct SocialFeedView: View {
  private let person = MockConstants.persons[0]
  private let exercise = MockConstants.exercise
  
  @State var searchQuery: String = ""
  
  var body: some View {
    VStack(spacing: 5) {
      searchBar
        .padding(.bottom, 5)
      FeedCardView(person: person, exercise: exercise, onFollow: {}, onLike: { isLiked in
      print(isLiked)
      })
      Spacer()
    }
    .background(.black)
  }
  
  // MARK: - Views
  @ViewBuilder
  private var searchBar: some View {
    SearchBarView(placeholderText: "", searchQuery: $searchQuery, onFiltersTapped: {
      
    })
  }
}

#Preview {
  SocialFeedView()
}
