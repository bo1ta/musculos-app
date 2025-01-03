//
//  RouteLiveScreen.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 30.12.2024.
//

import CoreLocation
import RouteKit
import SwiftUI
import Utility

public struct RouteLiveScreen: View {
  @State private var averagePace: Double = 0

  public init() { }

  public var body: some View {
    GeometryReader { proxy in
      VStack {
        RouteMap(averagePace: $averagePace)
        Spacer()
      }
      .ignoresSafeArea()
      .frame(height: proxy.size.height - 200)
      .overlay {
        VStack {
          Spacer()
          HStack {
            Spacer()
            Circle()
              .frame(height: 50)
              .overlay {
                VStack {
                  Text(String(averagePace))
                    .font(AppFont.poppins(.bold, size: 18))
                  Text("min/km")
                    .font(AppFont.poppins(.regular, size: 11))
                }
                .foregroundStyle(.white)
              }
          }
        }
        .padding(20)
      }
    }
  }
}

#Preview {
  RouteLiveScreen()
}
