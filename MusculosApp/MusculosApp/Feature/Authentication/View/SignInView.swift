//
//  SignInView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Utility

struct SignInView: View {
  @Environment(\.userStore) private var userStore
  @State private var viewModel = AuthViewModel()
    
  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        Spacer()
        
        Text(headerTitle)
          .font(.header(.bold, size: 25))
        Text(bodyTitle)
          .font(.body(.light, size: 14))
        
        loginForm
          .padding([.top, .bottom], 20)
        
//        socialLoginSection
        
        Spacer()
        signUpButton
      }
      .padding(.horizontal, 20)
      .onDisappear(perform: viewModel.cleanUp)
      .navigationTitle("")
      .navigationDestination(isPresented: $viewModel.showRegister) {
        SignUpView(viewModel: viewModel)
      }
      .onChange(of: viewModel.state) { _, state in
        switch state {
        case .error(let errorMessage):
          MusculosLogger.logError(MusculosError.badRequest, message: errorMessage, category: .networking)
        case .loaded(_):
          userStore.setIsLoggedIn(true)
        default:
          break
        }
      }
    }
  }
}

// MARK: - Views

extension SignInView {
  private var loginForm: some View {
    VStack(alignment: .center, spacing: 15) {
      CustomTextField(text: $viewModel.email,
                       label: "Email")
      CustomTextField(text: $viewModel.password,
                       label: "Password",
                       isSecureField: true)
      .padding([.top, .bottom], 10)
      
      Button(action: viewModel.signIn, label: {
        Text("Sign in")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButtonStyle())
    }
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
    Button(action: {
      viewModel.showRegister.toggle()
    }, label: {
      Text(dontHaveAnAccountTitle)
        .font(.body(.light, size: 15))
    })
  }
}

// MARK: - Constants

extension SignInView {
  private var headerTitle: String {
    "Welcome! 👋"
  }
  
  private var bodyTitle: String {
    "Sign in to start your fitness journey"
  }
  private var dontHaveAnAccountTitle: String {
    "Don't have an account? Sign up now"
  }
}


#Preview {
  SignInView()
}
