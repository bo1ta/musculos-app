//
//  SplashScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Components
import SwiftUI
import Utility

struct SplashScreen: View {
  @State private var showLoginScreen = false
  @State private var initialAuthStep = AuthenticationViewModel.Step.login

  var body: some View {
    VStack {
      if showLoginScreen {
        AuthenticationScreen(
          initialStep: initialAuthStep,
          onBack: {
            showLoginScreen = false
          })
          .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
      } else {
        splashScreen
          .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
      }
    }
    .background(AppColor.navyBlue)
    .animation(.smooth(duration: UIConstant.AnimationDuration.medium), value: showLoginScreen)
  }

  private var splashScreen: some View {
    ZStack {
      SineWaveView(
        waveSize: .constant(1.2),
        backgroundColor: .white,
        wavePosition: .bottom,
        waveColors: [AppColor.navyBlue],
        isAnimated: false)

      VStack(alignment: .center) {
        Image("male-character-sitting")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .shadow(radius: 10)
          .frame(width: 400, height: 400)
        Spacer()

        PrimaryButton(title: "Sign up", action: goToSignUp)
          .padding(.horizontal, 40)

        header

        PrimaryButton(title: "Sign In", action: goToSignIn)
          .padding(.horizontal, 40)
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

  private func goToSignIn() {
    lightHapticFeedback()

    initialAuthStep = .login
    showLoginScreen = true
  }

  private func goToSignUp() {
    lightHapticFeedback()

    initialAuthStep = .register
    showLoginScreen = true
  }

  private func lightHapticFeedback() {
    HapticFeedbackProvider.haptic(.lightImpact)
  }
}

#Preview {
  SplashScreen()
}
