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
      .frame(maxHeight: 400)
      .overlay(content: {
        VStack(spacing: 0) {
          topSection
          .padding([.leading, .trailing], 10)
          
          Image("weightlifting-background")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: 300)
          
          bottomSection
          .padding([.leading, .trailing], 10)
          .padding(.top, -10)
          
        }
      })
      .padding([.leading, .trailing], 10)
      .shadow(radius: 5)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var topSection: some View {
    HStack(spacing: 0) {
      PersonAvatarCircle(persons: [person])
        .shadow(radius: 2)
      
      VStack {
        Text(person.name)
          .font(.title3)
          .bold()
          .shadow(radius: 2)
        Text("just completed an exercise!")
          .font(.caption)
          .shadow(radius: 2)
      }
      Spacer()
      
      Button(action: onFollow, label: {
        Text("Follow")
          .font(.body)
          .foregroundStyle(.black)
          .bold()
          .shadow(radius: 2)
      })
    }
  }
  
  @ViewBuilder
  private var bottomSection: some View {
    HStack {
      Text(exercise.name)
        .font(.title3)
        .shadow(radius: 2)
      
      Spacer()
      
      Button(action: {
        isLiked.toggle()
        onLike(isLiked)
      }, label: {
        Image(systemName: isLiked ? "heart.fill" : "heart")
          .foregroundStyle(.black)
          .shadow(radius: 2)
      })
    }
  }
}

#Preview {
  FeedCardView(person: MockConstants.persons[0], exercise: MockConstants.exercise, onFollow: {}, onLike: { _ in })
}
