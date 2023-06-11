//
//  LoginView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    
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
                                Image(systemName: "person")
                                    .foregroundColor(.secondary)
                                TextField("Email", text: self.$viewModel.username)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            .padding()
                            .background(Capsule().fill(.white))
                            
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
                        Button(action: {}, label: {
                            Text("Forgot password?")
                                .padding(.leading, 150)
                                .foregroundColor(.white)
                        })
                        
                        Button(action: {
                            self.viewModel.authenticateUser()
                        }, label: {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(PrimaryButton())
                        .opacity(self.viewModel.isFormValid ? 1 : 0.5)
                        .disabled(!self.viewModel.isFormValid)
                        .padding(.top, 50)
                        .padding([.trailing, .leading], 23)
                        
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
