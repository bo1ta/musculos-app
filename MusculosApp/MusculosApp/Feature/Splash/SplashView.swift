//
//  SplashView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Components
import Utility

struct SplashView: View {
  @State private var showLoginScreen: Bool = false
  @State private var initialAuthStep: AuthViewModel.Step = .login

  var body: some View {
    VStack {
      if showLoginScreen {
        AuthView(
          initialStep: initialAuthStep,
          onBack: {
            showLoginScreen = false
          }
        )
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from:. top)))
      } else {
        splashScreen
          .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
      }
    }
    .background(AppColor.navyBlue)
    .animation(.smooth(duration: UIConstant.defaultAnimationDuration), value: showLoginScreen)
  }

  private var splashScreen: some View {
    ZStack {
      SineWaveView(
        waveCount: 1,
        baseAmplitude: 0.17,
        backgroundColor: Color.white,
        wavePosition: .top,
        waveColors: [AppColor.navyBlue],
        isAnimated: false
      )

      VStack(alignment: .center) {
        Image("male-character-sitting")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .shadow(radius: 10)
          .frame(width: 400, height: 400)
        Spacer()

        signUpButton
        header
        signInButton

      }
      .foregroundStyle(.red)
      .padding(.bottom, 80)
    }
    .background(Color.AppColor.blue200)
  }

  private var header: some View {
    Text("Already a member?")
      .padding(20)
      .font(AppFont.poppins(.semibold, size: 18))
      .foregroundStyle(.white)
  }

  private var signInButton: some View {
    Button(action: {
      lightHapticFeedback()
      withAnimation {
        initialAuthStep = .login
        showLoginScreen = true
      }
    }, label: {
      Text("Sign In")
        .frame(maxWidth: .infinity)
        .font(AppFont.poppins(.semibold, size: 20))
        .shadow(radius: 2)
    })
    .buttonStyle(PrimaryButtonStyle())
    .shadow(radius: 1.0)
    .padding(.horizontal, 40)
  }

  private var signUpButton: some View {
    Button(action: {
      lightHapticFeedback()

      withAnimation {
        initialAuthStep = .register
        showLoginScreen = true
      }
    }, label: {
      Text("Sign Up")
        .frame(maxWidth: .infinity)
        .font(AppFont.poppins(.semibold, size: 20))
        .shadow(radius: 2)
    })
    .buttonStyle(PrimaryButtonStyle())
    .shadow(radius: 1.0)
    .padding(.horizontal, 40)
  }

  private func lightHapticFeedback() {
    HapticFeedbackProvider.hapticFeedback(.lightImpact)
  }
}

#Preview {
  SplashView()
}
