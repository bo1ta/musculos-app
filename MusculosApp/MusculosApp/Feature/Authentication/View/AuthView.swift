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
  @State private var waveSize: Double
  @State private var horizontalOffset: Double
  @State private var timer: Timer?
  @State private var isWaveForward = false

  init(initialStep: AuthViewModel.Step) {
    self._waveSize = State(initialValue: initialStep == .login ? 0.1 : 0.9)
    self._horizontalOffset = State(initialValue: initialStep == .login ? -1 : 1)

    viewModel = AuthViewModel(initialStep: initialStep)
  }

  var body: some View {
    ZStack {
      waveShape

      authStep
    }
    .onAppear {
      startWaveAnimation()
    }
    .onDisappear {
      stopWaveAnimation()
      viewModel.cleanUp()
    }
    .onReceive(viewModel.event, perform: { event in
      handleAuthEvent(event)
    })
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
        SignInView(viewModel: viewModel)
          .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
      case .register:
        SignUpView(viewModel: viewModel)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      }
    }
    .animation(.smooth(duration: UIConstant.standardAnimationTime), value: viewModel.step)
  }

  private var waveShape: some View {
    WaveShapeAnimatable(waveSize: waveSize, horizontalOffset: horizontalOffset)
      .fill(
        LinearGradient(
          gradient: Gradient(colors: [Color.AppColor.blue800, Color.AppColor.blue700]), startPoint: .top, endPoint: .bottom)
        )
      .ignoresSafeArea()
      .animation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0), value: waveSize)
  }

  private func handleStepUpdate(_ step: AuthViewModel.Step) {
    withAnimation {
      waveSize = step == .login ? 0.1 : 0.8
      horizontalOffset = step == .login ? -1 : 1
    }
  }

  private func startWaveAnimation() {
    timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { value in
      withAnimation {
        if horizontalOffset > 2 {
          isWaveForward = false
        } else if horizontalOffset < -2 {
          isWaveForward = true
        }

        horizontalOffset += isWaveForward ? 0.03 : -0.03
      }
    })
  }

  private func handleAuthEvent(_ event: AuthViewModel.Event) {
    switch event {
    case let .onLoginSuccess(userSession):
      userStore.handlePostLogin(session: userSession)
    case let .onRegisterSuccess(userSession):
      userStore.handlePostRegister(session: userSession)
    case let .onLoginFailure(error):
      break
    case let .onRegisterFailure(error):
      break
    }
  }

  private func stopWaveAnimation() {
    timer?.invalidate()
    timer = nil
  }
}

#Preview {
  AuthView(initialStep: .login)
}
