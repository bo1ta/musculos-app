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

      headerStack
        .padding(.bottom, 40)

      registerForm

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

// MARK: - Subviews

extension SignUpView {
  private var headerStack: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(AppFont.header(.bold, size: 25))
          .foregroundStyle(.white)
          .shadow(radius: 1.2)
      })
      Spacer()
    }
  }

  private var backButton: some View {
    HStack {
      Button(action: showLogin, label: {
        Image(systemName: "chevron.left")
          .font(Font.body(.bold, size: 18))
          .foregroundStyle(.white)
      })

      Spacer()
    }
    .padding(.horizontal, 20)
  }

  @ViewBuilder
  private var registerForm: some View {
    VStack(alignment: .leading, spacing: 10) {
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
  }
}

#Preview {
  AuthenticationScreen(initialStep: .register, onBack: {})
}
