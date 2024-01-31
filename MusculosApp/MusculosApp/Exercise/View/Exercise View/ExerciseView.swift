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
  @EnvironmentObject private var tabBarSettings: TabBarSettings
  
  let exercise: Exercise
  let onBack: () -> Void
  
  @ObservedObject var viewModel: ExerciseViewModel
  
  init(exercise: Exercise, onBack: @escaping () -> Void) {
    self.exercise = exercise
    self.onBack = onBack
    self.viewModel = ExerciseViewModel(exercise: exercise)
  }
  
  var body: some View {
    VStack(spacing: 5) {
      header
        .padding(.bottom, 10)
      
      ScrollView {
        if viewModel.shouldShowAnatomyView {
          anatomyView
        } else {
          CurrentWorkoutCardView(exercise: exercise, showDetails: false, isGif: true)
            .padding(.bottom, 5)
            .shadow(radius: 2)
          exerciseCallouts
          Divider()
            .padding([.leading, .trailing], 20)
            .opacity(0.5)
          instructionsList
            .padding([.leading, .top], 5)
        }
      }
      .scrollIndicators(.hidden)

      Spacer()
    }
    .padding(10)
    .onAppear {
      viewModel.loadLocalData()
        tabBarSettings.isTabBarHidden = true
    }
    .onDisappear {
      tabBarSettings.isTabBarHidden = false
    }
    .navigationBarBackButtonHidden()
    .navigationTitle("")
    .toolbar(.hidden, for: .tabBar)
    .background(Color.white)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var exerciseCallouts: some View {
    HStack {
      IconPill(option: IconPillOption(title: exercise.bodyPart), backgroundColor: .cyan)
      IconPill(option: IconPillOption(title: exercise.equipment), backgroundColor: .green)
      
      Spacer()
      
      favoriteButton
    }
    .padding([.leading, .trailing, .bottom], 10)
  }
  
  @ViewBuilder
  private var favoriteButton: some View {
    Button {
      viewModel.toggleFavorite()
    } label: {
      Image(systemName: "heart.fill")
        .foregroundStyle(viewModel.isFavorite ? .red : .black)
        .fontWeight(.bold)
        .opacity(viewModel.isFavorite ? 1.0 : 0.7)
    }
  }
  
  @ViewBuilder
  private var backButton: some View {
    Button(action: {
      dismiss()
      onBack()
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
      backButton
        .padding(.leading, 15)
      Spacer()
      
      Text(exercise.name)
        .foregroundStyle(.black)
        .font(.title2)
        .bold()
        .padding(.leading, -15)
        .padding(.trailing, 15)
        .lineLimit(0)
        .shadow(radius: 1)
      Spacer()
    }
  }
  
  @ViewBuilder
  private var instructionsList: some View {
    ForEach(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
        createListItem(index: index, instruction: instruction)
    }
  }
  
  @ViewBuilder
  private var anatomyView: some View {
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

  @ViewBuilder
  private func createListItem(index: Int, instruction: String) -> some View {
    let rectangleHeight: CGFloat = instruction.count < 30 ? 30 : CGFloat(instruction.count / 2)
    RoundedRectangle(cornerRadius: 12)
      .frame(height: rectangleHeight)
      .foregroundStyle(.white)
      .shadow(radius: 2)
      .border(Color.appColor(with: .grassGreen).opacity(0.1))
      .overlay {
        HStack {
          Text(instruction)
            .font(.caption)
            .lineLimit(nil)
            .padding(.leading, 10)
            .shadow(radius: 4)
          Spacer()
        }
      }
//
//    VStack(alignment: .leading, spacing: 0) {
//      HStack {
//        Circle()
//          .frame(width: 25, height: 25)
//          .foregroundStyle(.black)
//          .overlay {
//            VStack {
//              Text("\(index + 1)")
//                .foregroundStyle(.white)
//                .font(.caption)
//            }
//          }
//        Text(instruction)
//          .font(.body)
//          .padding(.leading, 5)
//        Spacer()
//      }
//      Rectangle()
//        .fill(.blue)
//        .frame(width: 1, height: rectangleHeight, alignment: .leading)
//        .padding(.leading, 12)
//    }
//    .padding(2)

  }
}

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(exercise: MockConstants.exercise, onBack: {})
      .environmentObject(TabBarSettings(isTabBarHidden: true))
  }
}
