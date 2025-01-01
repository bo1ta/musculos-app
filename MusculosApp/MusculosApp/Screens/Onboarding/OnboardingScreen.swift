//
//  OnboardingScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Components
import HealthKitUI
import SwiftUI
import Utility

// MARK: - OnboardingScreen

struct OnboardingScreen: View {
  @State private var viewModel = OnboardingViewModel()

  var body: some View {
    VStack {
      BackButton(onPress: viewModel.handleBack)
      OnboardingWizard(viewModel: viewModel)
    }
    .padding(10)
    .frame(alignment: .top)
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
    .withKeyboardDismissingOnTap()
  }
}

#Preview {
  OnboardingScreen()
}
