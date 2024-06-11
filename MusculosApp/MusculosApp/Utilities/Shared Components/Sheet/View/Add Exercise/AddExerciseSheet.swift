//
//  AddExerciseSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI

struct AddExerciseSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.appManager) private var appManager
  
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
      
      RoundedTextField(
        text: $viewModel.exerciseName,
        label: "Name",
        textHint: "Exercise Name"
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
      
      WhiteBackgroundCard()
    }
    .scrollIndicators(.hidden)
    .padding([.leading, .trailing, .top], 15)
    .sheet(isPresented: $showPhotosPicker, content: {
      PhotosPicker(assets: $pickedPhotos)
    })
    .onReceive(viewModel.didSaveSubject, perform: { isSuccessful in
      if isSuccessful {
        appManager.showToast(style: .success, message: "Exercise saved successfuly!")
        appManager.notifyModelUpdate(.didAddExercise)
        dismiss()
      } else {
        appManager.showToast(style: .error, message: "Error saving exercise. Please try again.")
      }
    })
    .safeAreaInset(edge: .bottom) {
      Button(action: {
        viewModel.saveExercise()
      }, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding([.leading, .trailing], 10)
    }
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
