//
//  SplashView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI
import Components

struct SplashView: View {
  @State private var showLoginScreen: Bool = false
  
  var body: some View {
    VStack {
      WaveShape()
        .fill(LinearGradient(
          gradient: Gradient(colors: [Color.AppColor.blue500, Color.AppColor.blue400]),
          startPoint: .topTrailing,
          endPoint: .bottomTrailing))
        .overlay(content: {
          VStack(alignment: .leading) {
            Spacer()
            Text("Let's start your fitness journey today with us!")
              .font(.header(.bold, size: 35))
              .foregroundStyle(.white)
            Button(action: {
              showLoginScreen = true
            }, label: {
              Text("Continue")
                .frame(maxWidth: .infinity)
            })
            .buttonStyle(SecondaryButtonStyle())
            .shadow(radius: 1.0)
          }
          .padding(.bottom, 80)
          .padding(.horizontal, 10)
        })
        .ignoresSafeArea()
    }
    .background {
      Image("exercising-energy")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
    }
    .popover(isPresented: $showLoginScreen, content: {
      SignInView()
    })
  }
}

#Preview {
  SplashView()
}
