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
  @Bindable var viewModel: AuthViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Spacer()

      header
      registerForm
      LoadableDotsButton(
        title: "Sign Up",
        isLoading: viewModel.makeLoadingBinding(),
        isDisabled: !viewModel.isRegisterFormValid,
        action: viewModel.signUp
      )
      .padding(.top, 10)

      Spacer()
    }
    .gesture(
      DragGesture()
        .onEnded({ gesture in
          if gesture.translation.width > 30 {
            showLogin()
          }
        })
    )
    .padding(.horizontal, 20)
    .onDisappear(perform: viewModel.cleanUp)
    .safeAreaInset(edge: .top) {
      backButton
    }
  }

  private func showLogin() {
    viewModel.step = .login
  }
}

// MARK: - Subviews

extension SignUpView {

  private var header: some View {
    Text("Sign Up")
      .font(.header(.bold, size: 45))
      .foregroundStyle(.white)
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
        hint: "Email"
      )
      FormField(
        text: $viewModel.password,
        hint: "Password",
        isSecureField: true
      )
      FormField(
        text: $viewModel.confirmPassword,
        hint: "Confirm password",
        isSecureField: true
      )
      FormField(
        text: $viewModel.username,
        hint: "Username"
      )
    }
  }
}

#Preview {
  SignUpView(viewModel: AuthViewModel(initialStep: .login))
}
