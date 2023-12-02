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
    VStack {
      searchBar
        .shadow(radius: 2)
      feedCards
        .shadow(radius: 3)
    }
    .background(Color.appColor(with: .background))
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var searchBar: some View {
    SearchBarView(placeholderText: "", searchQuery: $searchQuery)
  }
  
  @ViewBuilder
  private var feedCards: some View {
    let enumeratedCards = Array(MockConstants.persons.enumerated())
    List(enumeratedCards, id: \.element.uuid) { index, person in
      Section {
        FeedCardView(person: person, exercise: exercise, onFollow: {
        }, onLike: { isLiked in
          print(isLiked)
        })
        .frame(maxWidth: .infinity)
      }
    }
    .listStyle(.plain)
  }
}

#Preview {
  SocialFeedView()
}
