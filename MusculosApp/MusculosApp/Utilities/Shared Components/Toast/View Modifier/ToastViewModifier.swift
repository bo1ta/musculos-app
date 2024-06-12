//
//  ToastViewModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          toastView
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) { _, value in
        showToast()
      }
  }
  
  @ViewBuilder
  var toastView: some View {
    if let toast = toast {
      VStack {
        ToastView(
          style: toast.style,
          message: toast.message,
          width: toast.width
        )
        Spacer()
      }
      .padding(.top)
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
