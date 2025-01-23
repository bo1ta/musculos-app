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
  @State private var viewModel: AuthenticationViewModel

  /// used for the wave animation
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
        baseWaveColor: AppColor.navyBlue)

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
      .animation(.smooth(duration: UIConstant.AnimationDuration.medium), value: viewModel.step)
    }
    .onChange(of: viewModel.step) { _, step in
      handleStepUpdate(step)
    }
    .dismissingGesture(
      direction: .left,
      action: {
        if viewModel.step == .register {
          viewModel.step = .login
        }
      })
    .background(Color.AppColor.blue200)
  }

  private func handleStepUpdate(_ step: AuthenticationViewModel.Step) {
    waveSize = step == .login ? originalSignInWaveSize : originalSignUpWaveSize
  }
}

#Preview {
  AuthenticationScreen(initialStep: .login, onBack: { })
}
