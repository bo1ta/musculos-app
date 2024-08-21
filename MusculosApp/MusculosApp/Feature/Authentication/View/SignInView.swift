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
  @Environment(\.navigationRouter) private var navigationRouter
  @Bindable var viewModel: AuthViewModel

  var onBack: () -> Void

  var body: some View {
    VStack {
      headerStack
      loginForm

      PrimaryButton(title: "Sign in", action: viewModel.signIn)
        .padding(.horizontal, 15)

      dontHaveAnAccountSection

      Spacer()
    }
    .padding([.horizontal, .vertical], 35)
  }
}

// MARK: - Subviews

extension SignInView {

  private var headerStack: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(AppFont.header(.bold, size: 25))
          .foregroundStyle(.black)
      })
      Spacer()
      Text("Sign In")
        .font(AppFont.poppins(.bold, size: 35))
        .foregroundColor(.black)
        .shadow(color: .black.opacity(0.5), radius: 2.5)
        .padding(.trailing, 20)
      Spacer()
    }
  }

  @ViewBuilder
  private var loginForm: some View {
    @Bindable var viewModel = viewModel
    let hintColor = Color.black

    VStack(spacing: 15) {
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
        .foregroundStyle(.gray)
        .shadow(radius: 0.3)
      
      Button(action: {
        viewModel.step = .register
      }, label: {
        Text("Sign up")
          .font(Font.body(.bold, size: 16))
          .foregroundStyle(.gray)
          .shadow(radius: 0.3)
      })
    }
    .padding(.top)
  }
}

#Preview {
  AuthView(initialStep: .login, onBack: {})
}
