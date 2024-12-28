//
//  AuthenticationScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Components
import SwiftUI
import Utility

struct AuthenticationScreen: View {
  @Environment(\.userStore) private var userStore

  @State private var viewModel: AuthenticationViewModel
  @State private var toast: Toast?

  // used for the wave animation
  @State private var waveSize: CGFloat

  private let originalSignInWaveSize = 1.9
  private let originalSignUpWaveSize = 1.7

  var onBack: () -> Void

  init(initialStep: AuthenticationViewModel.Step, onBack: @escaping () -> Void) {
    _waveSize = State(initialValue: initialStep == .login ? originalSignInWaveSize : originalSignUpWaveSize)
    viewModel = AuthenticationViewModel(initialStep: initialStep)
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
    .onDisappear(perform: viewModel.cleanUp)
    .onReceive(viewModel.eventPublisher, perform: handleAuthEvent(_:))
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

  private func handleStepUpdate(_ step: AuthenticationViewModel.Step) {
    waveSize = step == .login ? originalSignInWaveSize : originalSignUpWaveSize
  }

  private func handleAuthEvent(_ event: AuthenticationViewModel.Event) {
    switch event {
    case let .onLoginSuccess(userSession), let .onRegisterSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case let .onLoginFailure(error):
      toast = .init(style: .error, message: "Could not register. Please try again later")
      Logger.error(error, message: "Login failed")
    case let .onRegisterFailure(error):
      toast = .init(style: .error, message: "Could not register. Please try again later")
      Logger.error(error, message: "Register failed")
    }
  }
}

#Preview {
  AuthenticationScreen(initialStep: .login, onBack: {})
}
