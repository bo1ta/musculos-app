//
//  AddExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.10.2023.
//

import SwiftUI

struct AddExerciseView: View {
  @State private var exerciseName: String = ""
  @State private var exerciseType: String = ""
  @State private var equipment: String = ""
  @State private var selectedMuscles: [MuscleInfo] = []
  @State private var shouldSelectMuscles: Bool = false
  @State private var instructions: [Int: String] = [0: ""]

  var body: some View {
      VStack {
        self.headerBar
        ScrollView {
          VStack(spacing: 10) {
            self.makeLeadingText("Name")
            CustomTextFieldView(text: $exerciseName)

            self.makeLeadingText("Type")
            CustomTextFieldView(text: $exerciseType)

            self.makeLeadingText("Equipment")
            CustomTextFieldView(text: $equipment)

            self.makeLeadingText("Muscles")
            self.fakeMusclesFieldView

            self.makeLeadingText("Instructions")
            DynamicTextFieldListView(items: self.$instructions)
          }
          .padding(10)
        }
      }
    .popover(isPresented: $shouldSelectMuscles, content: {
      SelectMuscleView(selectedMuscles: self.$selectedMuscles)
    })
  }

  @ViewBuilder
  private func makeLeadingText(_ text: String) -> some View {
    HStack {
      Text(text)
        .foregroundStyle(.white)
      Spacer()
    }
    .padding(.leading, 10)
  }

  @ViewBuilder
  private var fakeMusclesFieldView: some View {
    Button(action: {
      self.shouldSelectMuscles = true
    }, label: {
      ZStack {
        RoundedRectangle(cornerRadius: 30)
          .frame(height: 55)
          .foregroundStyle(.white)

        HStack {
          if let commaSeparatedMuscles = self.commaSeparatedMuscles {
            Text(commaSeparatedMuscles)
              .font(.callout)
              .foregroundStyle(.black)
          }
          Spacer()
        }
        .padding(.leading, 30)
      }
    })
  }

  @ViewBuilder
  private var headerBar: some View {
    HStack {
      EmptyView()
      Spacer()
      Text("Add exercise")
        .font(.title)
        .foregroundStyle(.white)
        .shadow(radius: 10)
      Spacer()
      IconButtonView(systemImage: "checkmark")
        .padding(.trailing, 5)
    }
  }

  private var commaSeparatedMuscles: String? {
    guard self.selectedMuscles.count > 0 else { return nil }
    let selectedNames = self.selectedMuscles.compactMap { $0.name }
    let muscleSet: Set<String> = Set(selectedNames)
    return muscleSet.joined(separator: ", ")
  }
}

#Preview {
  AddExerciseView()
}
