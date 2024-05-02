//
//  AddGoalSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

struct AddGoalSheet: View {
  @EnvironmentObject private var appManager: AppManager
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = AddGoalSheetViewModel()
  
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
      
      SingleOptionSelectView(
        showOptions: $viewModel.showCategoryOptions,
        selectedOption: $viewModel.category,
        title: "Category",
        options: GoalConstants.categoryOptions
      )
      
      RoundedTextField(text: $viewModel.targetValue, label: "Target value")
      
      DatePicker(
        "End Date",
        selection: $viewModel.endDate,
        displayedComponents: [.date]
      )
      Spacer()
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
  }
}

#Preview {
  AddGoalSheet(onBack: {})
    .environmentObject(AppManager())
}
