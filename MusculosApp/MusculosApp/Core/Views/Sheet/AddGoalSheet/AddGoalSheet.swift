//
//  AddGoalSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Components
import Foundation
import Models
import SwiftUI
import Utility

struct AddGoalSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel = AddGoalSheetViewModel()

  var onBack: () -> Void

  var body: some View {
    ScrollView {
      SheetNavBar(
        title: "Add a new goal",
        onBack: onBack,
        onDismiss: { dismiss() })
        .padding(.vertical, 25)

      VStack(spacing: 20) {
        FormField(text: $viewModel.name, label: "Name")
        FormField(text: $viewModel.targetValue, label: "Target value", keyboardType: .numberPad)
        SingleOptionSelectView(
          showOptions: $viewModel.showCategoryOptions,
          selectedOption: $viewModel.category,
          title: "Category",
          options: GoalConstants.categoryOptions)
        SingleOptionSelectView(
          showOptions: $viewModel.showFrequencyOptions,
          selectedOption: $viewModel.frequency,
          title: "Frequency",
          options: GoalConstants.frequencyOptions)
        DatePicker(
          "End Date",
          selection: $viewModel.endDate,
          displayedComponents: [.date])
          .opacity(viewModel.showEndDate ? 1 : 0)
          .padding(.top)
      }
    }
    .padding([.horizontal, .top], 15)
    .padding(.bottom, 30)
    .frame(alignment: .top)
    .safeAreaInset(edge: .bottom) {
      Button(action: viewModel.saveGoal, label: {
        Text("Save")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(ActionButtonStyle())
      .padding(.horizontal, 20)
    }
    .onReceive(viewModel.didSavePublisher, perform: { _ in
      dismiss()
    })
    .onDisappear(perform: viewModel.cancelTask)
  }
}

#Preview {
  AddGoalSheet(onBack: { })
}
