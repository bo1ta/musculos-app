//
//  SplashLoadingView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import SwiftUI
import Utility

struct SplashLoadingView: View {
  var body: some View {
    VStack {
      Image("workout-tools-man")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
    }
    .background(Color.AppColor.blue400)
    .ignoresSafeArea()
  }
}

#Preview {
    SplashLoadingView()
}
