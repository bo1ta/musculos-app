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
    ScrollView {
      searchBar
        .shadow(radius: 2)
        feedCards
          .shadow(radius: 3)

      .background(Color.appColor(with: .background))
    }
  }
  
  // MARK: - Views

  @ViewBuilder
  private var searchBar: some View {
    SearchBarView(placeholderText: "", searchQuery: $searchQuery)
      
  }
  
  @ViewBuilder
  private var feedCards: some View {
    VStack {
      FeedCardView(person: MockConstants.persons[0], exercise: exercise, onFollow: {}, onLike: { isLiked in
        print(isLiked)
      })
      FeedCardView(person: MockConstants.persons[1], exercise: exercise, onFollow: {}, onLike: { isLiked in
        print(isLiked)
      })
      FeedCardView(person: MockConstants.persons[2], exercise: exercise, onFollow: {}, onLike: { isLiked in
        print(isLiked)
      })
    }
  }
}

#Preview {
  SocialFeedView()
}
