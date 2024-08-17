//
//  AuthView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI
import Utility
import Components

struct AuthView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.appManager) private var appManager

  @State private var viewModel: AuthViewModel

  // used for the wave animation
  @State private var waveSize: Double
  @State private var horizontalOffset: Double

  var onBack: () -> Void

  init(initialStep: AuthViewModel.Step, onBack: @escaping () -> Void) {
    self._waveSize = State(initialValue: initialStep == .login ? 0.1 : 0.9)
    self._horizontalOffset = State(initialValue: initialStep == .login ? -1 : 1)

    self.viewModel = AuthViewModel(initialStep: initialStep)
    self.onBack = onBack
  }

  var body: some View {
    ZStack {
      SineWaveView(
        waveCount: 8,
        backgroundColor: Color.white,
        waveColors: [
          AppColor.navyBlue.opacity(
            0.3
          ),
          AppColor.navyBlue,
          AppColor.navyBlue,
          AppColor.navyBlue,
          AppColor.navyBlue,
          AppColor.navyBlue,
          AppColor.navyBlue,
          AppColor.navyBlue
        ]
      )

      authStep
    }
    .onDisappear {
      viewModel.cleanUp()
    }
    .onReceive(viewModel.event, perform: { event in
      handleAuthEvent(event)
    })
    .onChange(of: viewModel.step) { _, step in
      handleStepUpdate(step)
    }
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
    .animation(.smooth(duration: UIConstant.defaultAnimationDuration), value: viewModel.step)
  }

  private func handleStepUpdate(_ step: AuthViewModel.Step) {
    withAnimation {
      waveSize = step == .login ? 0.1 : 0.8
      horizontalOffset = step == .login ? -1 : 1
    }
  }

  private func handleAuthEvent(_ event: AuthViewModel.Event) {
    switch event {
    case let .onLoginSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case let .onRegisterSuccess(userSession):
      userStore.handlePostRegister(session: userSession)
    case .onLoginFailure(_):
      appManager.showToast(style: .error, message: "Could not log in. Please try again later")
    case .onRegisterFailure(_):
      appManager.showToast(style: .error, message: "Could not register in. Please try again later")
    }
  }
}

#Preview {
  AuthView(initialStep: .login, onBack: {})
}

