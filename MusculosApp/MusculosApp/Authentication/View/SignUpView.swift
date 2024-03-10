//
//  SignUpView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct SignUpView: View {
  @EnvironmentObject private var viewModel: AuthViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Sign up")
        .font(.header(.regular, size: 25))
      registerForm
      socialLoginSection
    }
    .padding([.leading, .trailing], 20)
    .onDisappear(perform: viewModel.cleanUp)
  }
}

// MARK: - Views

extension SignUpView {
  private var registerForm: some View {
    VStack(alignment: .leading, spacing: 15) {
      RoundedTextField(text: $viewModel.email,
                       label: "Email",
                       textHint: "Enter email")
      RoundedTextField(text: $viewModel.password,
                       label: "Password",
                       textHint: "Enter password",
                       isSecureField: true)
      RoundedTextField(text: $viewModel.username,
                       label: "Username",
                       textHint: "Enter username")
      RoundedTextField(text: $viewModel.fullName,
                       label: "Full Name (optional)",
                       textHint: "Enter full name")
      
      Button(action: viewModel.signUp, label: {
        Text("Sign up")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButton())
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
          Text("Sign up using Google")
            .font(.body(.light, size: 15))
            .foregroundStyle(Color.AppColor.green700)
        })
        Button(action: {}, label: {
          Text("Sign up using Facebook")
            .font(.body(.light, size: 15))
            .foregroundStyle(Color.AppColor.green700)
        })
        .padding(.top, 5)
    }
  }
}

#Preview {
  SignUpView().environmentObject(AuthViewModel())
}
