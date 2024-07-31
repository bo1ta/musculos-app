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
      Text(headerTitle)
        .font(.header(.bold, size: 45))
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1)

      loginForm

      signUpButton
    }
    .padding(.horizontal, 20)
  }
}

// MARK: - Subviews

extension SignInView {

  @ViewBuilder
  private var loginForm: some View {
    @Bindable var viewModel: AuthViewModel = viewModel

    VStack(alignment: .center, spacing: 15) {
      FormField(
        text: $viewModel.email,
        hint: "Email"
      )
      FormField(
        text: $viewModel.password,
        hint: "Password",
        isSecureField: true
      )

      LoadableDotsButton(title: "Sign In", isLoading: viewModel.makeLoadingBinding(), action: viewModel.signIn)
        .padding(.top, 10)
    }
    .padding(.vertical, 20)
  }

  private var socialLoginSection: some View {
    VStack {
      HStack {
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.gray)
          .opacity(0.3)
        Text("OR LOG IN WITH")
          .font(.header(.bold, size: 13))
          .foregroundStyle(.gray)
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.gray)
          .opacity(0.3)
      }
      HStack {
        Button(action: {}, label: {
          Text("Google").frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButtonStyle())
        Button(action: {}, label: {
          Text("Facebook").frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButtonStyle())
      }
    }
  }

  private var signUpButton: some View {
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
