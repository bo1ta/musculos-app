//
//  AddGoalSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI
import Models
import Components
import Utility

struct AddGoalSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel = AddGoalSheetViewModel()

  var body: some View {
    VStack(spacing: 25) {
      SheetNavBar(
        title: "Set a new goal",
        onBack: { dismiss() },
        onDismiss: { dismiss() }
      )

      CustomTextField(
        text: $viewModel.name,
        label: "Name"
      )
      
      CustomTextField(
        text: $viewModel.targetValue,
        label: "Target value",
        keyboardType: .numberPad
      )
      
      SingleOptionSelectView(
        showOptions: $viewModel.showCategoryOptions,
        selectedOption: $viewModel.category,
        title: "Category",
        options: GoalConstants.categoryOptions
      )
      
      SingleOptionSelectView(
        showOptions: $viewModel.showFrequencyOptions,
        selectedOption: $viewModel.frequency,
        title: "Frequency",
        options: GoalConstants.frequencyOptions
      )
      
      if viewModel.showEndDate {
        DatePicker(
          "End Date",
          selection: $viewModel.endDate,
          displayedComponents: [.date]
        )
        .padding(.top)
        .font(.body(.bold, size: 15))
      }
      
      Spacer()
    }
    .padding([.horizontal, .top], 15)
    .safeAreaInset(edge: .bottom) {
      Button(action: {
        viewModel.saveGoal()
      }, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding(.horizontal, 10)
    }
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
    .onDisappear {
      viewModel.cleanUp()
    }
  }
}

#Preview {
  AddGoalSheet()
}
