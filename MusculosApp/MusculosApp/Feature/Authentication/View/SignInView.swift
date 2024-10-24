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
    VStack(alignment: .center, spacing: 20) {
      Spacer()

      headerStack
      loginForm

      LoadableButton(title: "Sign in", isLoading: $viewModel.isLoading, action: viewModel.signIn)
        .padding(.horizontal, 15)

      dontHaveAnAccountSection

      Spacer()
    }
    .padding([.horizontal], 35)
  }
}

// MARK: - Subviews

extension SignInView {

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

  @ViewBuilder
  private var loginForm: some View {
    @Bindable var viewModel = viewModel
    let labelColor = Color.white

    VStack(spacing: 10) {
      FormField(
        text: $viewModel.email,
        label: "Email",
        labelColor: labelColor
      )
      FormField(
        text: $viewModel.password,
        label: "Password",
        labelColor: labelColor,
        isSecureField: true
      )
    }
    .padding(.vertical, 20)
  }

  private var dontHaveAnAccountSection: some View {
    HStack {
      Text("Don't have an account?")
        .font(AppFont.poppins(.regular, size: 15))
        .shadow(radius: 0.3)
      
      Button(action: {
        viewModel.step = .register
      }, label: {
        Text("Sign up")
          .font(AppFont.poppins(.bold, size: 17))
          .shadow(radius: 0.3)
      })
    }
    .foregroundStyle(.white)
  }
}

#Preview {
  AuthView(initialStep: .login, onBack: {})
}
