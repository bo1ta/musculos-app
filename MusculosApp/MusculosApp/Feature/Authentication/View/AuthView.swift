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

  @State private var viewModel: AuthViewModel

  // used for the wave animation
  @State private var waveSize: CGFloat

  var onBack: () -> Void

  init(initialStep: AuthViewModel.Step, onBack: @escaping () -> Void) {
    self._waveSize = State(initialValue: initialStep == .login ? 0.5 : 0.2)
    self.viewModel = AuthViewModel(initialStep: initialStep)
    self.onBack = onBack
  }

  var body: some View {
    ZStack {
      SineWaveView(
        waveCount: 8,
        waveSize: $waveSize,
        backgroundColor: Color.white,
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
    waveSize = step == .login ? 0.5 : 0.2
  }

  private func handleAuthEvent(_ event: AuthViewModel.Event) {
    switch event {
    case let .onLoginSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case let .onRegisterSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case .onLoginFailure(let error):
      MusculosLogger.logError(
        error,
        message: "Could not login",
        category: .networking
      )
    case .onRegisterFailure(let error):
      MusculosLogger.logError(
        error,
        message: "Could not register",
        category: .networking
      )
    }
  }
}

#Preview {
  AuthView(initialStep: .login, onBack: {})
}

