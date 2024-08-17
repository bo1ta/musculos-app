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
      signUpButton
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

  private var signUpButton: some View {
    Button(action: {
      viewModel.signUp()
    }, label: {
      Text("Sign Up")
        .frame(maxWidth: .infinity)
        .font(AppFont.poppins(.semibold, size: 20))
        .shadow(radius: 2)
    })
    .padding(.horizontal, 40)
    .buttonStyle(PrimaryButtonStyle())
  }

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
  AuthView(initialStep: .register, onBack: {})
}
