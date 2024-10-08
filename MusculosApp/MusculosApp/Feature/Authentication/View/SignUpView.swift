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
  let onBack: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Spacer()

      headerStack
        .padding(.bottom, 40)

      registerForm

      PrimaryButton(title: "Sign up", action: viewModel.signUp)
        .padding(.horizontal, 15)
        .padding(.top, 10)

      Spacer()
    }
    .dismissingGesture(direction: .left, action: showLogin)
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
  private var headerStack: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(AppFont.header(.bold, size: 25))
          .foregroundStyle(.black)
      })
      Spacer()
      Text("Sign Up")
        .font(AppFont.poppins(.bold, size: 35))
        .foregroundColor(.black)
        .shadow(color: .black.opacity(0.5), radius: 2.5)
        .padding(.trailing, 20)
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
        label: "Email"
      )
      FormField(
        text: $viewModel.password,
        label: "Password",
        isSecureField: true
      )
      FormField(
        text: $viewModel.confirmPassword,
        label: "Confirm password",
        isSecureField: true
      )
      FormField(
        text: $viewModel.username,
        label: "Username"
      )
    }
  }
}

#Preview {
  AuthView(initialStep: .register, onBack: {})
}
