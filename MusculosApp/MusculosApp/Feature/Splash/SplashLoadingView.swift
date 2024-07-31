//
//  SplashLoadingView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.07.2024.
//

import SwiftUI
import SwiftUIGIF
import Utility

struct SplashLoadingView: View {
  var body: some View {
    VStack {
      GIFImage(name: "loading-animated")
        .imageScale(.large)
    }
    .background(Color.AppColor.blue400)
    .ignoresSafeArea()
  }
}

#Preview {
    SplashLoadingView()
}
