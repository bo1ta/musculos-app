//
//  ExerciseFilterSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.02.2024.
//

import Components
import Models
import SwiftUI
import Utility

struct ExerciseFilterSheet: View {
  @Environment(\.navigator) private var navigator
  @Environment(\.dismiss) private var dismiss

  @State private var viewModel = ExerciseFilterSheetViewModel()

  private var searchButtonText: String {
    if !viewModel.results.isEmpty {
      "Show (\(viewModel.results.count)) results"
    } else {
      "Search"
    }
  }

  var body: some View {
    VStack(spacing: 10) {
      header
      ScrollView {
        VStack(spacing: 20) {
          MultiOptionsSelectView(
            showOptions: viewModel.makeFilterDisplayBinding(for: .muscle),
            selectedOptions: viewModel.makeSearchFilterBinding(for: .muscle),
            title: "Muscles",
            options: ExerciseConstants.muscleOptions)
          MultiOptionsSelectView(
            showOptions: viewModel.makeFilterDisplayBinding(for: .category),
            selectedOptions: viewModel.makeSearchFilterBinding(for: .category),
            title: "Workout Types",
            options: ExerciseConstants.categoryOptions)
          SingleOptionSelectView(
            showOptions: viewModel.makeFilterDisplayBinding(for: .difficulty),
            selectedOption: $viewModel.selectedLevelFilter,
            title: "Difficulty",
            options: ExerciseConstants.levelOptions)
          MultiOptionsSelectView(
            showOptions: viewModel.makeFilterDisplayBinding(for: .equipment),
            selectedOptions: viewModel.makeSearchFilterBinding(for: .equipment),
            title: "Equipment",
            options: ExerciseConstants.equipmentOptions)
        }
        .padding(.top, 10)
      }
      .padding(.horizontal, 10)
      .scrollIndicators(.hidden)
      .safeAreaInset(edge: .bottom, content: {
        Button(action: handleSearch, label: {
          Text(searchButtonText)
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(ActionButtonStyle())
        .padding()
        .padding(.bottom, 10)
      })
      .onAppear {
        HapticFeedbackProvider.prepareHaptic(.selection)
      }
    }
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
    navigator.returnToCheckpoint(.explore, value: viewModel.results)
    dismiss()
  }
}

#Preview {
  ExerciseFilterSheet()
}
