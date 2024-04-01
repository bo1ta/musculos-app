//
//  SignInView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct SignInView: View {
  @EnvironmentObject private var userStore: UserStore
  @ObservedObject private var viewModel = AuthViewModel()
    
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
        
        socialLoginSection
        
        Spacer()
        signUpButton
      }
      .padding([.leading, .trailing], 20)
      .onDisappear(perform: viewModel.cleanUp)
      .navigationTitle("")
      .navigationDestination(isPresented: $viewModel.showRegister) {
        SignUpView(viewModel: _viewModel)
      }
      .onChange(of: viewModel.state) { state in
        switch state {
        case .error(let errorMessage):
          MusculosLogger.logError(MusculosError.badRequest, message: errorMessage, category: .networking)
          break
        case .loaded(_):
          DispatchQueue.main.async {
            userStore.isLoggedIn = true
          }
        default:
          break
        }
      }
    }
    .overlay {
      if viewModel.state == .loading {
        LoadingOverlayView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()
      }
    }
  }
}

// MARK: - Private views

extension SignInView {
  private var loginForm: some View {
    VStack(alignment: .center, spacing: 15) {
      RoundedTextField(text: $viewModel.email,
                       label: "Email",
                       textHint: "Enter email")
      RoundedTextField(text: $viewModel.password,
                       label: "Password",
                       textHint: "Enter password",
                       isSecureField: true)
      .padding([.top, .bottom], 10)
      
      Button(action: viewModel.signIn, label: {
        Text("Sign in")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButton())
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
        .buttonStyle(SecondaryButton())
        Button(action: {}, label: {
          Text("Facebook").frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButton())
      }
    }
  }
  
  private var signUpButton: some View {
    Button(action: {
      DispatchQueue.main.async {
        viewModel.showRegister = true
      }
    }, label: {
      HStack(spacing: 5) {
        Text(dontHaveAnAccountTitle)
          .font(.body(.light, size: 15))
        Text(signUpButtonTitle)
          .font(.body(.light, size: 15))
          .foregroundStyle(Color.AppColor.green700)
      }
      
    })
    .buttonStyle(SecondaryButton())
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
  
  private var signUpButtonTitle: String {
    "Sign up now"
  }
  
  private var dontHaveAnAccountTitle: String {
    "Don't have an account?"
  }
}


#Preview {
  SignInView()
    .environmentObject(UserStore())
}
