//
//  AuthenticationView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel: AuthenticationViewModel
    @State private var path = NavigationPath()
    
    private var isRegister: Bool {
        return self.viewModel.currentStep == .register
    }
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            backgroundView {
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
            .onAppear(perform: {
                if UserDefaultsWrapper.shared.authToken != nil {
                    self.path.append("IntroductionView")
                }
            })
            .onReceive(viewModel.authSuccess, perform: { _ in
                self.path.append("IntroductionView")
            })
            .navigationDestination(for: String.self) { view in
                if view == "IntroductionView" {
                    IntroductionView(viewModel: IntroductionViewModel())
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    private var contentView: some View {
        VStack {
            HearTipView(title: "Transform your body and mind", text: "With the ultimate weight and activity tracking app for anyone who wants to take control of their health and fitness")
            TransparentContainerView {
                authenticationForm
                
                if !self.isRegister {
                    Button(action: {}, label: {
                        Text("Forgot password?")
                            .padding(.leading, 150)
                            .foregroundColor(Color.appColor(with: .violetBlue))
                    })
                }
                
                primaryBtn
                dontHaveAnAccountBtn
                
                Spacer()
            }
            .overlay(loadingOverlay)
        }
    }
    
    @ViewBuilder private var authenticationForm: some View {
        VStack {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.secondary)
                TextField("Email", text: self.$viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding()
            .background(Capsule().fill(.white))
            
            if self.isRegister {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Username", text: self.$viewModel.username)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                .padding()
                .background(Capsule().fill(.white))
                .transition(.scale)
            }
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.secondary)
                SecureField("Password", text: self.$viewModel.password)
                    .textContentType(.password)
            }
            .padding()
            .background(Capsule().fill(.white))
        }
        .padding([.leading, .trailing], 10)
    }
    
    @ViewBuilder private var primaryBtn: some View {
        Button(action: {
            self.viewModel.handleAuthentication()
        }, label: {
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
    
    @ViewBuilder private var dontHaveAnAccountBtn: some View {
        Button(action: {
            withAnimation(Animation.linear(duration: 0.2)) {
                self.viewModel.handleNextStep()
            }
        }, label: {
            Text(self.isRegister ? "Already have an account?" : "Don't have an account?")
                .foregroundColor(Color.appColor(with: .violetBlue))
        })
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        if self.viewModel.isLoading {
            ZStack {
                Color(white: 0, opacity: 0.75)
                ProgressView().tint(.white)
            }
        }
    }
    
    @ViewBuilder private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack {
            Image("throwing-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            content()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel())
    }
}
