//
//  SplashView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Components

struct SplashView: View {
  @State private var showLoginScreen: Bool = false
  @State private var initialAuthStep: AuthViewModel.Step = .login

  var body: some View {
    VStack {
      if showLoginScreen {
        AuthView(initialStep: initialAuthStep)
          .transition(.asymmetric(insertion: .push(from: .bottom), removal: .slide))
      } else {
        splashScreen
          .transition(.asymmetric(insertion: .opacity, removal: .push(from: .bottom)))
      }
    }
    .animation(.smooth(duration: UIConstant.standardAnimationTime), value: showLoginScreen)
  }

  private var splashScreen: some View {
    WaveShape()
      .fill(
        LinearGradient(
          gradient: Gradient(colors: [Color.AppColor.blue800, Color.AppColor.blue700]),
          startPoint: .bottomTrailing,
          endPoint: .topTrailing
        )
      )
      .overlay {
        VStack(alignment: .center) {
          Spacer()

          Text("Start your workout plan today")
            .padding(20)
            .font(Font.header(.bold, size: 25))
            .foregroundStyle(.white)

          Button(action: {
            withAnimation {
              showLoginScreen = true
            }
          }, label: {
            Text("Log In")
              .frame(maxWidth: .infinity)
              .font(Font.body(.regular, size: 16))
          })
          .buttonStyle(SecondaryButtonStyle())
          .shadow(radius: 1.0)
          .padding(.horizontal, 30)

          HStack {
            Text("Don't have an account?")
              .font(Font.body(.regular, size: 16))
              .foregroundStyle(.white)
              .shadow(radius: 0.3)

            Button(action: {
              initialAuthStep = .register
              showLoginScreen = true
            }, label: {
              Text("Sign up")
                .font(Font.body(.bold, size: 16))
                .foregroundStyle(.white)
                .shadow(radius: 0.3)
            })
          }
          .padding(.top)
        }
        .padding(.bottom, 80)
      }
      .ignoresSafeArea()
      .background {
        Image("workout-tools-man")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .ignoresSafeArea()
      }
  }
}

#Preview {
  SplashView()
}
