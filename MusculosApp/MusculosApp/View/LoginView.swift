//
//  LoginView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    @State private var animateStepTransition = false
    
    private var isRegister: Bool {
        return self.viewModel.currentStep == .register
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image("throwing-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if self.viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    HearTip(title: "Transform your body and mind", text: "With the ultimate weight and activity tracking app for anyone who wants to take control of their health and fitness")
                                        
                    TransparentContainer {
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
                        
                        if !self.isRegister {
                            Button(action: {}, label: {
                                Text("Forgot password?")
                                    .padding(.leading, 150)
                                    .foregroundColor(.white)
                            })
                        }
                        
                        Button(action: {
                            self.viewModel.handleAuthentication()
                        }, label: {
                            Text(self.viewModel.currentStep == .login ? "Sign In" : "Sign Up")
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(PrimaryButton())
                        .opacity(self.viewModel.isFormValid ? 1 : 0.5)
                        .disabled(!self.viewModel.isFormValid)
                        .padding(.top, 50)
                        .padding([.trailing, .leading], 23)
                        
                        Button(action: {
                            withAnimation(Animation.linear(duration: 0.2)) {
                                self.animateStepTransition = true
                                self.viewModel.handleNextStep()
                            }
                        }, label: {
                            Text(self.isRegister ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(Color.appColor(with: .violetBlue))
                        })
                        
                        Spacer()
                    }
                    .onAppear(perform: {
                        viewModel.setupSubscriptions()
                    })
                    .alert(isPresented: self.$viewModel.showErrorAlert, content: {
                        Alert(title: Text("Something went wrong"), message: Text(self.viewModel.errorMessage ?? "Request timed out"), dismissButton: .default(Text("Ok"), action: {
                            self.viewModel.showErrorAlert = false
                        }))
                    })
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
