//
//  LoadingOverlayView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import SwiftUI

struct LoadingOverlayView: View {
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.75)
        .ignoresSafeArea()
      VStack {
        Spacer()
        loadingView
        Spacer()
      }
    }
  }
  
  private var loadingView: some View {
    VStack(spacing: 5) {
      GIFImageViewRepresentable(urlType: .name("loading-animated"), resize: CGSize(width: 50, height: 50))
        .frame(width: 300, height: 300)
      Text("Loading...")
        .font(.title3)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .shadow(radius: 1)
    }
  }
}

#Preview {
    LoadingOverlayView()
}
