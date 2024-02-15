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
        RoundedTextField(text: $viewModel.searchQuery, textHint: "Search", systemImageName: "magnifyingglass")
          .shadow(radius: 2, y: 1)
        ScrollView {
          VStack(spacing: 20) {
            FiltersSectionView(showFilters: $viewModel.showMuscleFilters, selectedFilters: $viewModel.selectedMuscleFilters, title: "Muscles", filters: viewModel.muscleFilters)
            FiltersSectionView(showFilters: $viewModel.showWorkoutFilters, selectedFilters: $viewModel.selectedCategoryFilters, title: "Workout Types", filters: viewModel.categoryFilters)
            FiltersSectionView(showFilters: $viewModel.showDifficultyFilters, selectedFilters: $viewModel.selectedDifficultyFilters, title: "Difficulty", filters: viewModel.levelFilters, isSingleSelect: true)
            durationSection
            FiltersSectionView(showFilters: $viewModel.showEquipmentFilter, selectedFilters: $viewModel.selectedCategoryFilters, title: "Equipment", filters: viewModel.equipmentFilters)
          }
          .padding(.top, 10)
        }
        .scrollIndicators(.hidden)
        .padding([.leading, .trailing], 10)
        .padding()
        Spacer()
      }
    }
    .safeAreaInset(edge: .bottom, content: {
      Button(action: {
       searchFilters()
        dismiss()
      }, label: {
        Text("Search")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding()
      .padding(.bottom, 10)
    })
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
              .font(.custom(AppFont.bold, size: 18))
            
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
            .font(.custom(AppFont.bold, size: 18))
          Spacer()
          Image(systemName: viewModel.showDurationFilter ? "chevron.up" : "chevron.down")
        }
        .foregroundStyle(.black)
      }
    }
    
    if viewModel.showDurationFilter {
      Slider(value: $viewModel.selectedDuration)
        .tint(Color.appColor(with: .customRed))
      Text("\(viewModel.selectedDuration)")
    }
  }
  
  private var backButton: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "arrow.left")
        .font(.custom(AppFont.regular, size: 18))
        .foregroundStyle(.black)
    }
  }
  
  private var resetButton: some View {
    Button {
      viewModel.resetFilters()
    } label: {
      Text("Reset")
        .foregroundStyle(.black)
        .font(.custom(AppFont.regular, size: 15))
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
    if viewModel.selectedDifficultyFilters.count > 0 {
      filters["level"] = viewModel.selectedDifficultyFilters
    }
    if viewModel.selectedEquipmentFilters.count > 0 {
      filters["equipment"] = viewModel.selectedEquipmentFilters
    }
    
    exerciseStore.loadFilteredExercises(with: filters)
  }
}

#Preview {
  SearchFilterView()
}
