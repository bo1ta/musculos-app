//
//  SignInView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Utility
import Components

struct SignInView: View {
  @Environment(\.userStore) private var userStore
  @Bindable var viewModel: AuthViewModel

  var body: some View {
    VStack(alignment: .center) {
      header
      loginForm
      LoadableDotsButton(
        title: "Sign In",
        isLoading: viewModel.makeLoadingBinding(),
        isDisabled: !viewModel.isLoginFormValid,
        action: viewModel.signIn
      )
      dontHaveAnAccountSection
    }
    .padding(.horizontal, 20)
  }
}

// MARK: - Subviews

extension SignInView {

  private var header: some View {
    Text(headerTitle)
      .font(.header(.bold, size: 45))
      .foregroundColor(.white)
      .shadow(color: .black.opacity(0.5), radius: 1)
  }

  @ViewBuilder
  private var loginForm: some View {
    @Bindable var viewModel = viewModel
    let hintColor = Color.AppColor.blue200

    VStack(alignment: .center, spacing: 15) {
      FormField(
        text: $viewModel.email,
        hint: "Email",
        hintColor: hintColor
      )
      FormField(
        text: $viewModel.password,
        hint: "Password",
        hintColor: hintColor,
        isSecureField: true
      )
    }
    .padding(.vertical, 20)
  }

  private var dontHaveAnAccountSection: some View {
    HStack {
      Text("Don't have an account?")
        .font(Font.body(.regular, size: 16))
        .foregroundStyle(.white)
        .shadow(radius: 0.3)
      Button(action: {
        viewModel.step = .register
      }, label: {
        Text("Sign up")
          .font(Font.body(.bold, size: 16))
          .foregroundStyle(.white)
          .shadow(radius: 0.3)
      })
    }
    .padding(.top)
  }
}

// MARK: - Constants

extension SignInView {
  private var headerTitle: String {
    "Welcome back!"
  }

  private var dontHaveAnAccountTitle: String {
    "Don't have an account? Sign up now"
  }
}


#Preview {
  AuthView(initialStep: .login)
}
