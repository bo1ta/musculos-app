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
            Image("exercising-energy")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if self.viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    HearTip(title: "Transform your body and mind", text: "With the ultimate weight and activity tracking app for anyone who wants to take control of their health and fitness")
                    
                    Image("profile-img")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(Circle())
                        .shadow(radius: 9.0, x: 20, y: 10)
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, content: {
                        TextField("Username", text: self.$viewModel.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(25.0)
                            .shadow(radius: 10.0, x: 5, y: 10)
                        SecureField("Password", text: self.$viewModel.password)
                            .textContentType(.password)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(25.0)
                            .shadow(radius: 10.0, x: 5, y: 10)
                    })
                    .padding([.leading, .trailing], 50)
                    Button(action: {}, label: {
                        Text("Forgot password?")
                            .padding(.leading, 150)
                            .foregroundColor(.white)
                    })
                    
                    Button(action: {
                        self.viewModel.authenticateUser()
                    }, label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 60)
                            .background(Color(.orange))
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    })
                    .opacity(buttonOpacity)
                    .disabled(!self.viewModel.isFormValid)
                    .padding(.top, 50)
                    
                    Spacer()
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear(perform: {
                viewModel.setupSubscriptions()
            })
        }
    }
    var buttonOpacity: Double {
        return self.viewModel.isFormValid ? 1 : 0.5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
