//
//  AddGoalSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

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
      
      RoundedTextField(
        text: $viewModel.name,
        label: "Name",
        textHint: "Goal name"
      )
      
      RoundedTextField(
        text: $viewModel.targetValue,
        label: "Target value"
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
    .padding()
    .safeAreaInset(edge: .bottom) {
      Button(action: {
        viewModel.saveGoal()
      }, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding([.leading, .trailing], 10)
    }
    .onDisappear {
      viewModel.cleanUp()
    }
  }
}

#Preview {
  AddGoalSheet(onBack: {})
}
