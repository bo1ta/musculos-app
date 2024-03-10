//
//  SignUpView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct SignUpView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize: CGSize
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var viewModel: AuthViewModel
  
  var body: some View {
    VStack {
      signupForm
    }
    .onDisappear(perform: viewModel.cleanUp)
    .frame(width: mainWindowSize.width, height: mainWindowSize.height)
    .toolbarRole(.editor)
    .toolbarBackground(.hidden, for: .navigationBar)
  }
  
  private var signupForm: some View {
    VStack(spacing: 15) {
      HStack {
        Text("Sign up")
          .font(.custom("Roboto-Regular", size: 25))
        Spacer()
      }
      .padding(.bottom, 10)
      
      RoundedTextField(text: $viewModel.email, label: "Email", textHint: "Enter email")
      RoundedTextField(text: $viewModel.password, label: "Password", textHint: "Enter password", isSecureField: true)
      RoundedTextField(text: $viewModel.username, label: "Username", textHint: "Enter username")
      RoundedTextField(text: $viewModel.fullName, label: "Full Name (optional)", textHint: "Enter full name")

      Button(action: {
        viewModel.signUp()
      }, label: {
        Text("Sign up")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButton())
      .padding(.top, 10)
      createAccountSection
    }
    .padding([.leading, .trailing], 20)
  }
  
  private var createAccountSection: some View {
    VStack {
      HStack {
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: mainWindowSize.width / 2)
          .foregroundStyle(.gray)
          .opacity(0.3)
        Text("or")
          .font(.custom("Roboto-Light", size: 19))
        Rectangle()
          .frame(height: 1)
          .frame(maxWidth: mainWindowSize.width / 2)
          .foregroundStyle(.gray)
          .opacity(0.3)
      }
      Button(action: {
        
      }, label: {
        Text("Sign up using Google").frame(maxWidth: .infinity)
      })
      .buttonStyle(SecondaryButton())
      Button(action: {
        
      }, label: {
        Text("Sign up using Facebook").frame(maxWidth: .infinity)
      })
      .buttonStyle(SecondaryButton())
      }
    }
}

#Preview {
  SignUpView().environmentObject(AuthViewModel())
}
