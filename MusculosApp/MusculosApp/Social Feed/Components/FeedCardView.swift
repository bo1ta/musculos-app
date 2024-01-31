//
//  FeedCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.11.2023.
//

import SwiftUI

struct FeedCardView: View {
  let person: Person
  let exercise: Exercise
  let onFollow: () -> Void
  let onLike: (Bool) -> Void
  
  @State private var isLiked = false
  
  var body: some View {
    Rectangle()
      .foregroundStyle(.white)
      .frame(minHeight: 350)
      .overlay(content: {
        VStack(alignment: .leading, spacing: 0) {
          topSection
          .padding([.leading, .trailing], 10)
          
          Image("weightlifting-background")
            .resizable()
            .padding(3)
            .cornerRadius(25)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, minHeight: 200)
            .overlay {
              VStack {
                Text(exercise.name)
                  .font(.title3)
                  .fontWeight(.heavy)
                  .foregroundStyle(.white)
              }
            }
          
          bottomSection
          .padding(15)
        }
      })
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var topSection: some View {
    HStack(spacing: 0) {
      PersonAvatarCircle(persons: [person])
        .shadow(radius: 2)
      
      VStack(alignment: .leading) {
        Text(person.username)
          .font(.body)
          .bold()
        Text("just completed an exercise")
          .font(.caption)
          .foregroundStyle(.gray)
      }
      .padding(.top)
      Spacer()
      
      Button(action: onFollow, label: {
        Text("Follow")
          .font(.caption)
          .foregroundStyle(.black)
          .bold()
      })
    }
    .padding(5)
  }
  
  @ViewBuilder
  private var bottomSection: some View {
    HStack {
      Button(action: {
        isLiked.toggle()
        onLike(isLiked)
      }, label: {
        Image(systemName: isLiked ? "heart.fill" : "heart")
          .foregroundStyle(.black)
      })
      Spacer()

    }
  }
}

#Preview {
  FeedCardView(person: MockConstants.persons[0], exercise: MockConstants.exercise, onFollow: {}, onLike: { _ in })
}
