//
//  AuthenticationScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI
import Utility
import Components

struct AuthenticationScreen: View {
  @Environment(\.userStore) private var userStore

  @State private var viewModel: AuthenticationViewModel
  @State private var toast: Toast? = nil

  // used for the wave animation
  @State private var waveSize: CGFloat

  private let originalSignInWaveSize = 1.9
  private let originalSignUpWaveSize = 1.7

  var onBack: () -> Void

  init(initialStep: AuthenticationViewModel.Step, onBack: @escaping () -> Void) {
    self._waveSize = State(initialValue: initialStep == .login ? originalSignInWaveSize : originalSignUpWaveSize)
    self.viewModel = AuthenticationViewModel(initialStep: initialStep)
    self.onBack = onBack
  }

  var body: some View {
    ZStack {
      SineWaveView(
        waveCount: 8,
        waveSize: $waveSize,
        backgroundColor: Color.white,
        wavePosition: .bottom,
        baseWaveColor: AppColor.navyBlue
      )
      authStep
    }
    .onDisappear {
      viewModel.cleanUp()
    }
    .onReceive(viewModel.eventPublisher, perform: { event in
      handleAuthEvent(event)
    })
    .onChange(of: viewModel.step) { _, step in
      handleStepUpdate(step)
    }
    .toastView(toast: $toast)
    .dismissingGesture(
      direction: .left,
      action: {
        if viewModel.step == .register {
          viewModel.step = .login
        }
      }
    )
    .background(Color.AppColor.blue200)
  }

  @ViewBuilder
  private var authStep: some View {
    Group {
      switch viewModel.step {
      case .login:
        SignInView(viewModel: viewModel, onBack: onBack)
          .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
      case .register:
        SignUpView(viewModel: viewModel, onBack: onBack)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      }
    }
    .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: viewModel.step)
  }

  private func handleStepUpdate(_ step: AuthenticationViewModel.Step) {
    waveSize = step == .login ? originalSignInWaveSize : originalSignUpWaveSize
  }

  private func handleAuthEvent(_ event: AuthenticationViewModel.Event) {
    switch event {
    case let .onLoginSuccess(userSession), let .onRegisterSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case .onLoginFailure(let error):
      toast = .init(style: .error, message: "Could not register. Please try again later")
      MusculosLogger.logError(error, message: "Login failed", category: .networking)
    case .onRegisterFailure(let error):
      toast = .init(style: .error, message: "Could not register. Please try again later")
      MusculosLogger.logError(error, message: "Register failed", category: .networking)
    }
  }
}

#Preview {
  AuthenticationScreen(initialStep: .login, onBack: {})
}

