//
//  SignInView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct SignInView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize: CGSize
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var userStore: UserStore
  
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var showRegister: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        ImageRectangleView(imageName: "red-patterns-background", rectangleColor: .appColor(with: .customRed))
        Spacer()
        detailsForm
      }
      .onChange(of: userStore.isLoggedIn, perform: { isLoggedIn in
        if isLoggedIn {
          dismiss()
        }
      })
      .ignoresSafeArea()
      .navigationDestination(isPresented: $showRegister) {
        RegisterView()
      }
      .overlay {
        if userStore.isLoading {
          LoadingOverlayView()
        }
      }
      .tint(.black)
    }
    .onDisappear {
      userStore.cancelTask()
    }
  }
  
  private var detailsForm: some View {
    VStack(alignment: .center, spacing: 15) {
      HStack {
        Text("Sign in")
          .font(.custom("Roboto-Regular", size: 25))
        Spacer()
      }
      CustomTextFieldView(text: $email, textHint: "Email", systemImageName: "envelope.fill")
      CustomTextFieldView(text: $password, textHint: "Password", systemImageName: "lock.fill", isSecureField: true)
      
      maybeShowErrorText()

      Button(action: {
        userStore.signIn(email: email, password: password)
      }, label: {
        Text("Sign in")
          .frame(maxWidth: .infinity)
          .foregroundStyle(.white)
      })
      .buttonStyle(PrimaryButton())
      
      createAccountSection
    }
    .padding(20)
    .frame(width: mainWindowSize.width, height: mainWindowSize.height)
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
        showRegister = true
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
