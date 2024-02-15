//
//  RegisterView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct RegisterView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize: CGSize
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var userStore: UserStore
  
  @State private var email: String = ""
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var fullName: String = ""
  
  var body: some View {
    VStack {
      signupForm
    }
    .onChange(of: userStore.isLoggedIn, perform: { isLoggedIn in
      if isLoggedIn {
        dismiss()
      }
    })
    .onDisappear(perform: userStore.cancelTask)
    .frame(width: mainWindowSize.width, height: mainWindowSize.height)
    .toolbarRole(.editor)
    .toolbarBackground(.hidden, for: .navigationBar)
    .overlay {
      if userStore.isLoading {
        LoadingOverlayView()
      }
    }
  }
  
  private var signupForm: some View {
    VStack(spacing: 15) {
      HStack {
        Text("Sign up")
          .font(.custom("Roboto-Regular", size: 25))
        Spacer()
      }
      .padding(.bottom, 10)
      
      Group {
        RoundedTextField(text: $email, textHint: "Email")
        RoundedTextField(text: $password, textHint: "Password", isSecureField: true)
        RoundedTextField(text: $username, textHint: "Username")
        RoundedTextField(text: $fullName, textHint: "Full Name (Optional)")
      }
      
      maybeShowErrorText()
      
      Button(action: {
        let person = Person(email: email, fullName: fullName, username: username)
        userStore.signUp(person: person, password: password)
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
  
  @ViewBuilder
  private func maybeShowErrorText() -> some View {
    if userStore.error != nil {
      Text("Something went wrong. Please try again")
        .font(.custom("Roboto-Light", size: 13))
        .foregroundStyle(.black)
    }
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
  RegisterView().environmentObject(UserStore())
}
