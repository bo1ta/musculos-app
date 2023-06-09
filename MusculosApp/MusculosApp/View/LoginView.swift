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
        VStack {
            Text("Welcome")
                .foregroundColor(.white)
                .padding([.top, .bottom], 50)
                .shadow(radius: 6.0, x: 10, y: 10)
            
            Image("profile-img")
                .resizable()
                .frame(width: 180, height: 180)
                .clipShape(Circle())
                .overlay(Circle())
                .shadow(radius: 9.0, x: 20, y: 10)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, content: {
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(25.0)
                    .shadow(radius: 10.0, x: 5, y: 10)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(25.0)
                    .shadow(radius: 10.0, x: 5, y: 10)
            })
            .padding([.leading, .trailing], 50)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Forgot password?")
                    .padding(.leading, 150)
                    .foregroundColor(.white)
            })
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 60)
                    .background(Color(.orange))
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            })
            .opacity(self.buttonOpacity)
            .disabled(!viewModel.isFormValid)
            .padding(.top, 50)
            
            Spacer()
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.white)
                
            }
        }
    }
    
    var buttonOpacity: Double {
        return viewModel.isFormValid ? 1 : 0.5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
