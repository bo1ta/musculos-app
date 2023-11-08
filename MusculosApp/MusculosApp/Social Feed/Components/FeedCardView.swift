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
  let onLike: () -> Void
  
  var body: some View {
    Rectangle()
      .foregroundStyle(.white)
      .frame(maxHeight: 450)
      .overlay(content: {
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            PersonAvatarCircle(persons: [person])
            
            VStack {
              Text(person.name)
                .font(.title3)
                .bold()
              Text("just completed an exercise!")
                .font(.caption)
            }
            Spacer()
            
            Button(action: onFollow, label: {
              Text("Follow")
                .font(.body)
                .bold()
            })
          }
          .padding([.leading, .trailing], 10)
          
          Image("weightlifting-background")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: 300)
          
          HStack {
            Text(exercise.name)
              .font(.title2)
            
            Spacer()
            
            Button(action: onLike, label: {
              Image(systemName: "heart")
            })
          }
          .padding([.leading, .trailing], 10)
          
        }
      })
      .padding([.leading, .trailing], 10)
      .shadow(radius: 5)
  }
}

#Preview {
  FeedCardView(person: MockConstants.persons[0], exercise: MockConstants.exercise, onFollow: {}, onLike: {})
}
