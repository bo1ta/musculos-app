//
//  ExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import SwiftUI
import CoreData

struct ExerciseView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) private var managedObjectContext
  
  let exercise: Exercise
  
  @ObservedObject var viewModel: ExerciseViewModel
  
  init(exercise: Exercise) {
    self.exercise = exercise
    self.viewModel = ExerciseViewModel(exercise: exercise)
  }
  
  var body: some View {
    VStack(spacing: 10) {
      header
        .padding(.bottom, 10)
      
      if viewModel.shouldShowAnatomyView {
        HStack {
          Spacer()
          
          if let frontAnatomyIds = viewModel.frontMuscles {
            AnatomyOverlayView(musclesIds: frontAnatomyIds)
          }
          
          if let backAnatomyIds = viewModel.backMuscles {
            AnatomyOverlayView(musclesIds: backAnatomyIds, isFront: false)
          }
          
          Spacer()
        }
      }
      
      backgroundView
        .frame(width: 200, height: 200)
      
      HStack {
        IconPill(option: IconPillOption(title: exercise.bodyPart), backgroundColor: .cyan)
        IconPill(option: IconPillOption(title: exercise.equipment), backgroundColor: .green)
        
        Spacer()
        
        favoriteButton
      }
      .padding([.leading, .trailing, .bottom], 10)
      
      
      List(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
        HStack {
          Text("\(index + 1)")
          Text(instruction)
            .
        }
      }
    }
    .onAppear {
      viewModel.loadData()
    }
  }
  
  @ViewBuilder
  private var favoriteButton: some View {
    Button {
      viewModel.toggleFavorite()
    } label: {
      Image(systemName: "heart.fill")
        .foregroundStyle(viewModel.isFavorite ? .red : .white)
        .fontWeight(.bold)
        .foregroundStyle(viewModel.isFavorite ? .white : .gray)
        .opacity(viewModel.isFavorite ? 1.0 : 0.7)
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    if let gifUrl = URL(string: exercise.gifUrl) {
      GIFView(url: Binding(get: { gifUrl }, set: { _ in }))
        .aspectRatio(contentMode: .fit)
        .padding(.top, 10)
    } else {
      Color.black
    }
  }
  
  @ViewBuilder
  private var backButton: some View {
    Button(action: {
      print("hei")
    }, label: {
      Image(systemName: "chevron.left")
        .resizable()
        .bold()
        .frame(width: 15, height: 20)
        .foregroundStyle(.black)
    })
  }
  
  @ViewBuilder
  private var header: some View {
    HStack {
      Group {
        backButton
          .padding(.leading, 15)
      }
      Spacer()
      
      Text(exercise.name)
        .foregroundStyle(.black)
        .font(.title2)
        .bold()
        .padding(.leading, -15)
      
      Spacer()
    }
  }
}

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
  }
}
