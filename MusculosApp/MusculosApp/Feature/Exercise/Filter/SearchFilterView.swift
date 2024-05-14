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
  
  @State private var results: [Exercise] = []
  
  private var searchButtonText: String {
    if results.count > 0 {
      return "Show (\(results.count))"
    } else {
      return "Search"
    }
  }
  
  var body: some View {
    VStack(spacing: 10) {
      header
      ScrollView {
        VStack(spacing: 20) {
          MultiOptionsSelectView(
            showOptions: viewModel.makeDisplayFilterBinding(for: .muscle),
            selectedOptions: viewModel.makeFilterBinding(for: .muscle),
            title: "Muscles",
            options: ExerciseConstants.muscleOptions
          )
          MultiOptionsSelectView(
            showOptions: viewModel.makeDisplayFilterBinding(for: .category),
            selectedOptions: viewModel.makeFilterBinding(for: .category),
            title: "Workout Types",
            options: ExerciseConstants.categoryOptions
          )
          SingleOptionSelectView(
            showOptions: viewModel.makeDisplayFilterBinding(for: .difficulty),
            selectedOption: $viewModel.selectedLevelFilter,
            title: "Difficulty",
            options: ExerciseConstants.levelOptions
          )
          MultiOptionsSelectView(
            showOptions: viewModel.makeDisplayFilterBinding(for: .equipment),
            selectedOptions: viewModel.makeFilterBinding(for: .equipment),
            title: "Equipment",
            options: ExerciseConstants.equipmentOptions
          )
        }
        .padding(.top, 10)
      }
      .scrollIndicators(.hidden)
      .safeAreaInset(edge: .bottom, content: {
        Button(action: handleSearch, label: {
          Text(searchButtonText)
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(PrimaryButtonStyle())
        .padding()
        .padding(.bottom, 10)
      })
      .onChange(of: viewModel.filters) { _ in
        handleFiltering()
      }
    }
    .padding([.leading, .trailing], 10)
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
  
  private func handleSearch() {
    /// update store with the filtered data
    ///
    if results.count > 0 {
      exerciseStore.state = .loaded(results)
    }
    dismiss()
  }
  
  private func handleFiltering() {
    let filters = viewModel.filters
    let muscles = filters[.muscle]
    let categories = filters[.category]
    let equipments = filters[.equipment]
    
    Task {
      let exercises = await self.exerciseStore.filterByMuscles(
        muscles: muscles ?? [],
        level: viewModel.selectedLevelFilter,
        categories: categories ?? [],
        equipments: equipments ?? []
      )
      self.results = exercises
    }
  }
}

#Preview {
  SearchFilterView()
}
