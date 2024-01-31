//
//  GetStartedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import SwiftUI

struct GetStartedView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize: CGSize
  @State private var showAuthenticationView: Bool = false
  var body: some View {
    VStack(alignment: .center) {
      Image("jogger-cartoon")
        .resizable()
        .frame(width: 250, height: 250)
        .shadow(radius: 1)
      Text("MuscleHustle")
        .font(.custom("Roboto-Bold", size: 40))
        .shadow(radius: 1)
      Text("Serious Gains, Hilarious Pain")
        .padding(.bottom, 30)
        .shadow(radius: 0.5)
      Button(action: {
        showAuthenticationView = true
      }, label: {
        Circle()
          .frame(width: 60, height: 60)
          .foregroundStyle(Color.appColor(with: .customRed))
          .overlay {
            Image(systemName: "arrow.forward")
              .fontWeight(.black)
              .font(Font.title3)
              .foregroundStyle(Color.white)
          }
      })
      .shadow(radius: 1)
    }
    .popover(isPresented: $showAuthenticationView, content: {
      AuthenticationView(performPostLogin: {})
    })
    .frame(width: mainWindowSize.width, height: mainWindowSize.height)
  }
}

#Preview {
  GetStartedView().environment(\.mainWindowSize, CGSize(width: 360, height: 450))
}
