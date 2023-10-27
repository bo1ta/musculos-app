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
      self.header
        .padding(.bottom, 10)

      if self.viewModel.shouldShowAnatomyView {
        HStack {
          Spacer()

          if let frontAnatomyIds = self.viewModel.frontMuscles {
            AnatomyOverlayView(musclesIds: frontAnatomyIds)
          }

          if let backAnatomyIds = self.viewModel.backMuscles {
            AnatomyOverlayView(musclesIds: backAnatomyIds, isFront: false)
          }

          Spacer()
        }
      }

      HStack {
        IconPill(option: IconPillOption(title: self.exercise.bodyPart))
        IconPill(option: IconPillOption(title: self.exercise.equipment))

        Spacer()

        let isFavorite = self.viewModel.isFavorite

        Button {
          DispatchQueue.main.async {
            self.viewModel.toggleFavorite()
          }
        } label: {
          Circle()
            .frame(width: 30, height: 30)
            .overlay(content: {
              Image(systemName: "heart.fill")
                .foregroundStyle(isFavorite == true ? .red : .white)
                .fontWeight(.bold)
            })
            .foregroundStyle(isFavorite ? .white : .gray)
            .opacity(isFavorite ? 1.0 : 0.7)
        }
      }
      .padding([.leading, .trailing, .bottom], 10)
      
      backgroundView
        .frame(width: 200, height: 200)
  

      List(self.exercise.instructions, id: \.self) { instruction in
        Text(instruction)
          .font(.caption)
          .foregroundStyle(.primary)
      }
    }
    .onAppear {
      self.viewModel.loadData()
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    if let gifUrl = URL(string: self.exercise.gifUrl) {
      GIFView(url: Binding(get: { gifUrl }, set: { _ in }))
    } else {
      Color.black
    }
  }

  @ViewBuilder
  private var header: some View {
    Rectangle()
      .foregroundColor(.black)
      .frame(maxHeight: 60)
      .overlay {
        HStack {
          Spacer()

          Text(self.exercise.name)
            .foregroundStyle(.white)
            .font(.title2)

          Spacer()
        }
      }
  }
}

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
  }
}
