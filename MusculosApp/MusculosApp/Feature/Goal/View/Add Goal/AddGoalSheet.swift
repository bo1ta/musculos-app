//
//  AddGoalSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI
import Models

struct AddGoalSheet: View {
  @Environment(\.appManager) private var appManager
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel = AddGoalSheetViewModel()
  
  let onBack: () -> Void
  
  var body: some View {
    VStack(spacing: 25) {
      SheetNavBar(
        title: "Set a new goal",
        onBack: onBack,
        onDismiss: {
          dismiss()
        })
      
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
    .onReceive(viewModel.didSaveGoalPublisher) { didSaveGoal in
      if didSaveGoal {
        appManager.showToast(style: .success, message: "Added new goal! Good luck!")
        appManager.notifyModelUpdate(.didAddGoal)
        dismiss()
      } else {
        appManager.showToast(style: .error, message: "Could not add goal. Please try again")
      }
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
    .onDisappear {
      viewModel.cleanUp()
    }
  }
}

#Preview {
  AddGoalSheet(onBack: {})
}
