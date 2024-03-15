//
//  CreateWorkoutSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct CreateWorkoutSheet: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var exerciseStore: ExerciseStore

  @State private var exerciseName: String = ""
  @StateObject private var categoryObserver = DebouncedQueryObserver()
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        topBar
        
        RoundedTextField(text: $exerciseName, label: "Name", textHint: "Workout Name")
          .padding(.top, 25)
        
        RoundedTextField(text: $categoryObserver.searchQuery, label: "Type", textHint: "Muscle Type")
          .padding(.top, 15)
        
        cardSection
          .padding(.top, 20)
      }
      .padding([.leading, .trailing, .top], 15)
      .onChange(of: categoryObserver.debouncedQuery) { categoryQuery in
        exerciseStore.searchByMuscleQuery(categoryQuery)
      }
    }
    .safeAreaInset(edge: .bottom) {
      Button(action: {}, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding([.leading, .trailing], 10)
    }
  }
  
  @ViewBuilder
  private var cardSection: some View {
    VStack(alignment: .leading) {
      Text("Recommended exercises")
        .font(.body(.bold, size: 15))
      
      switch exerciseStore.state {
      case .loading:
        VStack {
          CardItemShimmering()
          CardItemShimmering()
          CardItemShimmering()
          CardItemShimmering()
          CardItemShimmering()
          CardItemShimmering()
        }
      case .loaded(let exercises):
          ForEach(exercises, id: \.hashValue) { exercise in
            CardItem(title: exercise.name)
        }
      case .empty(_), .error(_):
        EmptyView()
      }
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
      
      Text("Create a new workout")
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
    .environmentObject(ExerciseStore())
}
