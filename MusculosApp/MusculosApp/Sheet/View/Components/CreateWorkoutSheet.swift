//
//  CreateWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct CreateWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State private var searchQuery: String = ""

  let onBack: () -> Void
  
  var body: some View {
    VStack(alignment: .leading) {
      topBar
        .padding([.leading, .trailing], 20)
      
      RoundedTextField(text: $searchQuery, textHint: "Search for exercise")
        .padding(.top, 25)
      
      FavoriteSectionItem(title: "Exercise 1", value: 5)
        .padding(.top, 25)
      FavoriteSectionItem(title: "Exercise 1", value: 5)
      FavoriteSectionItem(title: "Exercise 1", value: 5)
      FavoriteSectionItem(title: "Exercise 1", value: 5)
    }
  }
  
  private var topBar: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })

      Spacer()
      
      Text("Create new exercise")
        .font(.header(.bold, size: 20))
        .foregroundStyle(.black)
  
      Spacer()
      
      Button(action: {
          dismiss()
      }, label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
      
    }
  }
}

#Preview {
  CreateWorkoutSheet(onBack: {})
}
