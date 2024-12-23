//
//  AddExerciseSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI
import Models
import Utility
import Components
import Storage

struct AddExerciseSheet: View {
  @Environment(\.dismiss) private var dismiss

  @State private var viewModel = AddExerciseSheetViewModel()
  @State private var showPhotosPicker: Bool = false
  @State private var pickedPhotos: [PhotoModel] = []
  
  let onBack: () -> Void
  
  var body: some View {
    ScrollView {
      SheetNavBar(title: "Create a new exercise",
                  onBack: onBack,
                  onDismiss: {
        dismiss()
      })
      
      FormField(
        text: $viewModel.exerciseName,
        label: "Name"
      )
      .padding(.top, 25)
      
      MultiOptionsSelectView(
        showOptions: $viewModel.showMusclesOptions,
        selectedOptions: $viewModel.targetMuscles,
        title: "Muscles",
        options: ExerciseConstants.muscleOptions
      )
      .padding(.top, 25)
      
      imageOptionView
        .padding(.top, 25)
      
      AddDetailOptionCardView(options: $viewModel.instructions)
        .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showEquipmentOptions,
        selectedOption: $viewModel.equipment,
        title: "Category",
        options: ExerciseConstants.equipmentOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showForceOptions,
        selectedOption: $viewModel.force,
        title: "Force",
        options: ExerciseConstants.forceOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showLevelOptions,
        selectedOption: $viewModel.level,
        title: "Level",
        options: ExerciseConstants.levelOptions
      )
      .padding(.top, 25)
      
      SingleOptionSelectView(
        showOptions: $viewModel.showCategoryOptions,
        selectedOption: $viewModel.category,
        title: "Category",
        options: ExerciseConstants.categoryOptions
      )
      .padding(.top, 25)
    }
    .padding(.bottom, 30)
    .scrollIndicators(.hidden)
    .padding([.horizontal, .top], 15)
    .sheet(isPresented: $showPhotosPicker, content: {
      PhotosPicker(assets: $pickedPhotos)
    })
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
    .safeAreaInset(edge: .bottom) {
      Button(action: {
        viewModel.saveExercise()
      }, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding(.horizontal, 10)
      .padding(.bottom)
    }
    .onDisappear(perform: viewModel.onDisappear)
  }
  
  
  private var imageOptionView: some View  {
    VStack(alignment: .leading) {
      Text("Images (optional)")
        .font(.body(.bold, size: 15))
        .foregroundStyle(.black)
      
      HStack {
        if pickedPhotos.count > 0 {
          Spacer()
          LazyHGrid(rows: [GridItem(.flexible())], alignment: .center, content: {
            ForEach(pickedPhotos, id: \.id) { pickedPhoto in
              Image(uiImage: pickedPhoto.image)
                .resizable()
                .frame(width: 140, height: 70)
            }
          })
          Spacer()
        } else {
          Spacer()
          Button {
            showPhotosPicker.toggle()
          } label: {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 13, height: 13)
          }
          Spacer()
        }
      }
    }
  }
}

#Preview {
  AddExerciseSheet(onBack: {})
}
