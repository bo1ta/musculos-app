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
  
  var body: some View {
    FeedCardView(person: person, exercise: exercise, onFollow: {}, onLike: {})
  }
  
  // MARK: - Views

}

#Preview {
  SocialFeedView()
}
