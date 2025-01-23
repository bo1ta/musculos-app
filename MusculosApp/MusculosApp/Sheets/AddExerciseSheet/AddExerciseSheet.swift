//
//  AddExerciseSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import Components
import Models
import Storage
import SwiftUI
import Utility

struct AddExerciseSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel = AddExerciseSheetViewModel()

  let onBack: () -> Void

  var body: some View {
    ScrollView {
      SheetNavBar(
        title: "Create a new exercise",
        onBack: onBack,
        onDismiss: { dismiss() })
        .padding(.vertical, 25)

      VStack(alignment: .leading, spacing: 20) {
        FormField(text: $viewModel.exerciseName, label: "Name")
        MultiOptionsSelectView(
          showOptions: $viewModel.showMusclesOptions,
          selectedOptions: $viewModel.targetMuscles,
          title: "Muscles",
          options: ExerciseConstants.muscleOptions)
        AddDetailOptionCardView(options: $viewModel.instructions)
        SingleOptionSelectView(
          showOptions: $viewModel.showEquipmentOptions,
          selectedOption: $viewModel.equipment,
          title: "Category",
          options: ExerciseConstants.equipmentOptions)
        SingleOptionSelectView(
          showOptions: $viewModel.showForceOptions,
          selectedOption: $viewModel.force,
          title: "Force",
          options: ExerciseConstants.forceOptions)
        SingleOptionSelectView(
          showOptions: $viewModel.showLevelOptions,
          selectedOption: $viewModel.level,
          title: "Level",
          options: ExerciseConstants.levelOptions)
        SingleOptionSelectView(
          showOptions: $viewModel.showCategoryOptions,
          selectedOption: $viewModel.category,
          title: "Category",
          options: ExerciseConstants.categoryOptions)
        imageOptionView
      }
    }
    .padding(.bottom, 30)
    .scrollIndicators(.hidden)
    .padding([.horizontal, .top], 15)
    .sheet(isPresented: $viewModel.showPhotoPicker, content: {
      PhotosPicker(assets: $viewModel.pickedPhotos)
    })
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
    .safeAreaInset(edge: .bottom) {
      Button(action: viewModel.saveExercise, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(ActionButtonStyle())
      .padding(.horizontal, 10)
      .padding(.bottom)
    }
  }

  private var imageOptionView: some View {
    VStack(alignment: .leading) {
      Text("Images (optional)")
        .font(.body(.bold, size: 15))
        .foregroundStyle(.black)

      HStack {
        if !viewModel.pickedPhotos.isEmpty {
          LazyHGrid(rows: [GridItem(.flexible())], alignment: .center, content: {
            ForEach(viewModel.pickedPhotos) { pickedPhoto in
              Image(uiImage: pickedPhoto.image)
                .resizable()
                .frame(width: 140, height: 70)
            }
          })
        } else {
          Button(
            action: { viewModel.showPhotoPicker.toggle() },
            label: {
              Image(systemName: "plus")
                .foregroundStyle(.black)
            })
        }
      }
      .frame(alignment: .center)
    }
  }
}

#Preview {
  AddExerciseSheet(onBack: { })
}
