//
//  SearchFilterView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import SwiftUI

struct SearchFilterView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var exerciseStore: ExerciseStore
  
  @StateObject private var viewModel = SearchFilterViewModel()
  
  var body: some View {
    VStack(spacing: 10) {
      header
      
      VStack {
        RoundedTextField(
          text: $viewModel.searchQuery,
          label: "Search",
          textHint: "Enter search query"
        )
        ScrollView {
          VStack(spacing: 20) {
            MultiOptionsSelectView(
              showOptions: $viewModel.showMuscleFilters,
              selectedOptions: $viewModel.selectedMuscleFilters,
              title: "Muscles",
              options: ExerciseConstants.muscleOptions
            )
            MultiOptionsSelectView(
              showOptions: $viewModel.showWorkoutFilters,
              selectedOptions: $viewModel.selectedCategoryFilters,
              title: "Workout Types",
              options: ExerciseConstants.categoryOptions
            )
            SingleOptionSelectView(
              showOptions: $viewModel.showDifficultyFilters,
              selectedOption: $viewModel.selectedLevelFilter,
              title: "Difficulty",
              options: ExerciseConstants.levelOptions
            )
            MultiOptionsSelectView(
              showOptions: $viewModel.showEquipmentFilter,
              selectedOptions: $viewModel.selectedCategoryFilters,
              title: "Equipment",
              options: ExerciseConstants.equipmentOptions
            )
            
            durationSection
          }
          .padding(.top, 10)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom, content: {
          Button(action: {
            searchFilters()
            dismiss()
          }, label: {
            Text("Search")
              .frame(maxWidth: .infinity)
          })
          .buttonStyle(PrimaryButtonStyle())
          .padding()
          .padding(.bottom, 10)
        })
      }
      .padding([.leading, .trailing], 10)
    }
    .ignoresSafeArea()
  }
  
  private var header: some View {
    Rectangle()
      .frame(maxWidth: .infinity)
      .frame(height: 100)
      .foregroundStyle(.white)
      .shadow(radius: 3)
      .overlay {
        VStack {
          Spacer()
          HStack {
            backButton
            Spacer()
            
            Text("Search & filter")
              .font(.header(.bold, size: 18))
            
            Spacer()
            resetButton
          }
        }
        .padding()
      }
  }
  
  @ViewBuilder
  private var durationSection: some View {
    VStack {
      Button {
        viewModel.showDurationFilter.toggle()
      } label: {
        HStack {
          Text("Duration")
            .font(.header(.bold, size: 18))
          Spacer()
          Image(systemName: viewModel.showDurationFilter ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }
    }
    
    if viewModel.showDurationFilter {
      Slider(value: $viewModel.selectedDuration)
        .tint(Color.AppColor.blue500)
      Text("\(viewModel.selectedDuration)")
    }
  }
  
  private var backButton: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "arrow.left")
        .foregroundStyle(.black)
    }
  }
  
  private var resetButton: some View {
    Button {
      viewModel.resetFilters()
    } label: {
      Text("Reset")
        .foregroundStyle(.black)
        .font(.body(.regular, size: 15))
    }
  }
  
  private func searchFilters() {
    var filters: [String: [String]] = [:]
    if viewModel.selectedCategoryFilters.count > 0 {
      filters["category"] = viewModel.selectedCategoryFilters
    }
    if viewModel.selectedMuscleFilters.count > 0 {
      filters["muscles"] = viewModel.selectedMuscleFilters
    }
    if viewModel.selectedLevelFilter.count > 0 {
      filters["level"] = [viewModel.selectedLevelFilter]
    }
    if viewModel.selectedEquipmentFilters.count > 0 {
      filters["equipment"] = viewModel.selectedEquipmentFilters
    }
    
    exerciseStore.filterByMuscles(muscles: viewModel.selectedMuscleFilters)
  }
}

#Preview {
  SearchFilterView()
}
