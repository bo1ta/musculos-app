//
//  SignUpView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Components
import Utility

struct SignUpView: View {
  @Bindable var viewModel: AuthenticationViewModel
  let onBack: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Spacer()

      BackButton(onPress: onBack)
        .padding(.bottom, 40)

      VStack(alignment: .leading, spacing: 20) {
        FormField(
          text: $viewModel.email,
          label: "Email",
          labelColor: .white
        )
        FormField(
          text: $viewModel.password,
          label: "Password",
          labelColor: .white,
          isSecureField: true
        )
        FormField(
          text: $viewModel.confirmPassword,
          label: "Confirm password",
          labelColor: .white,
          isSecureField: true
        )
        FormField(
          text: $viewModel.username,
          label: "Username",
          labelColor: .white
        )
      }

      LoadableButton(title: "Sign up", isLoading: $viewModel.isLoading, action: viewModel.signUp)
        .padding(.horizontal, 15)
        .padding(.top, 10)

      Spacer()
    }
    .dismissingGesture(direction: .left, action: showLogin)
    .padding(.horizontal, 20)
    .onDisappear(perform: viewModel.cleanUp)
  }

  private func showLogin() {
    viewModel.step = .login
  }
}

#Preview {
  AuthenticationScreen(initialStep: .register, onBack: {})
}
