//
//  ToastViewModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import SwiftUI
import Utility

public struct ToastViewModifier: ViewModifier {
  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?

  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          toastView
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
        }
          .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: toast)
      )
      .onChange(of: toast) { _, value in
        showToast()
      }
  }

  @ViewBuilder
  var toastView: some View {
    if let toast = toast {
      VStack {
        Spacer()
        ToastView(
          style: toast.style,
          message: toast.message,
          width: toast.width
        )
      }
      .padding(.bottom, 100)
    }
  }

  private func showToast() {
    guard let toast = toast else { return }

    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()

    if toast.duration > 0 {
      workItem?.cancel()

      let task = DispatchWorkItem {
        dismissToast()
      }
      workItem = task

      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }

  private func dismissToast() {
    withAnimation {
      toast = nil
    }

    workItem?.cancel()
    workItem = nil
  }
}
