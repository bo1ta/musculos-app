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
      Text(headerTitle)
        .font(.header(.bold, size: 45))
        .foregroundStyle(.white)
      registerForm
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
  }

  private func showLogin() {
    viewModel.step = .login
  }
}

// MARK: - Views

extension SignUpView {

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
        text: $viewModel.password,
        hint: "Confirm password",
        isSecureField: true
      )
      FormField(
        text: $viewModel.username,
        hint: "Username"
      )

      LoadableDotsButton(title: headerTitle, isLoading: viewModel.makeLoadingBinding(), action: viewModel.signUp)
        .padding(.top, 10)
    }
  }
  
  private var socialLoginSection: some View {
    VStack(alignment: .center) {
      HStack {
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.gray)
          .opacity(0.3)
        Text("or")
          .font(.body(.regular, size: 19))
          .padding()
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: .infinity)
          .foregroundStyle(.gray)
          .opacity(0.3)
      }
      
        Button(action: {}, label: {
          Text(googleButtonTitle)
            .font(.body(.light, size: 15))
            .foregroundStyle(Color.AppColor.green700)
        })
  
        Button(action: {}, label: {
          Text(facebookButtonTitle)
            .font(.body(.light, size: 15))
            .foregroundStyle(Color.AppColor.green700)
        })
        .padding(.top, 5)
    }
  }
}

// MARK: - Constants

extension SignUpView {
  private var headerTitle: String {
    "Sign up"
  }
  
  private var googleButtonTitle: String {
    "Sign up using Google"
  }
  
  private var facebookButtonTitle: String {
    "Sign up using Facebook"
  }
}

#Preview {
  SignUpView(viewModel: AuthViewModel(initialStep: .login))
}
