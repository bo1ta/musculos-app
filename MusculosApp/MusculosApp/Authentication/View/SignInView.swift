//
//  SignInView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct SignInView: View {
  @Environment(\.dismiss) private var dismiss
  
  @StateObject var viewModel = AuthViewModel()
    
  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        Text("Welcome! 👋")
          .font(.header(.bold, size: 25))
        Text("Sign in to start your fitness journey")
          .font(.body(.light, size: 14))
        detailsForm
          .padding(.top, 20)
      }
      .padding([.leading, .trailing], 20)
      .navigationDestination(isPresented: $viewModel.showRegister) {
        SignUpView()
          .environmentObject(viewModel)
      }
    }
    .onDisappear {
      viewModel.cleanUp()
    }
  }
  
  
  
  private var detailsForm: some View {
    VStack(alignment: .center, spacing: 15) {
            
      RoundedTextField(text: $viewModel.email, label: "Email", textHint: "Enter email")
      RoundedTextField(text: $viewModel.password, label: "Password", textHint: "Enter password", isSecureField: true)
        .padding([.top, .bottom], 10)
  
      Button(action: {
        viewModel.signIn()
      }, label: {
        Text("Sign in")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButton())
      
      createAccountSection
    }
  }

  private var createAccountSection: some View {
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
        .buttonStyle(SecondaryButton())
        Button(action: {}, label: {
          Text("Facebook").frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButton())
      }
      
      Button(action: {
        viewModel.showRegister = true
      }, label: {
        Text("Don't have an account? Sign up here").frame(maxWidth: .infinity)
      })
      .buttonStyle(SecondaryButton())
    }
  }
}

#Preview {
  SignInView()
    .environment(\.mainWindowSize, CGSize(width: 360, height: 550))
    .environmentObject(UserStore())
}
