//
//  AuthenticationView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import SwiftUI

struct AuthenticationView: View {
  @StateObject private var viewModel = AuthenticationViewModel()
  
  private let performPostLogin: () -> Void
  
  init(performPostLogin: @escaping () -> Void) {
    self.performPostLogin = performPostLogin
  }

  private var isRegister: Bool {
    return self.viewModel.currentStep == .register
  }

  var body: some View {
    VStack {
      contentView
        .alert(isPresented: $viewModel.showErrorAlert) {
          Alert(
            title: Text("Something went wrong"),
            message: Text(viewModel.errorMessage ?? "Request timed out"),
            dismissButton: .default(Text("Ok")) {
              viewModel.showErrorAlert = false
            }
          )
        }
    }
    .onChange(of: viewModel.isAuthenticated, perform: { isAuthenticated in
      if isAuthenticated {
        performPostLogin()
      }
    })
    .background(backgroundImage)
    .overlay {
      if viewModel.isLoading {
        LoadingOverlayView()
      }
    }
  }

  private var contentView: some View {
    VStack {
      Spacer()
      TransparentContainerView {
        authenticationForm
          .padding(.bottom, 10)

        if !self.isRegister {
          Button(action: {
            
          }, label: {
            Text("Forgot password?")
              .padding(.leading, 150)
              .foregroundColor(Color.appColor(with: .violetBlue))
          })
        }

        primaryBtn
          .padding(.bottom, 10)
        dontHaveAnAccountBtn
      }
      Spacer()
    }
  }

  @ViewBuilder
  private var authenticationForm: some View {
    VStack {
      CustomTextFieldView(text: $viewModel.email, textHint: "Email", systemImageName: "envelope")

      if self.isRegister {
        CustomTextFieldView(text: $viewModel.username, textHint: "Username", systemImageName: "person")
          .transition(.scale)
      }

      CustomTextFieldView(text: $viewModel.password, textHint: "Password", systemImageName: "lock", isSecureField: true)

    }
    .padding([.leading, .trailing], 10)
  }

  @ViewBuilder
  private var primaryBtn: some View {
    Button(action: viewModel.handleAuthentication, label: {
      Text(self.viewModel.currentStep == .login ? "Sign In" : "Sign Up")
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.appColor(with: .violetBlue))
    })
    .buttonStyle(PrimaryButton())
    .opacity(self.viewModel.isFormValid ? 1 : 0.5)
    .disabled(!self.viewModel.isFormValid)
    .padding(.top, 20)
    .padding([.trailing, .leading], 23)
  }

  @ViewBuilder
  private var dontHaveAnAccountBtn: some View {
    Button(action: {
      withAnimation(Animation.linear(duration: 0.2)) {
        self.viewModel.handleNextStep()
      }
    }, label: {
      Text(self.isRegister ? "Already have an account?" : "Don't have an account?")
        .foregroundColor(Color.appColor(with: .violetBlue))
    })
  }

  @ViewBuilder
  private var backgroundImage: some View {
    Image("throwing-background")
      .resizable()
      .scaledToFill()
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(performPostLogin: {})
  }
}
