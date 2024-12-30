//
//  LiveRouteScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.12.2024.
//

import SwiftUI
import RouteKit
import CoreLocation

struct LiveRouteScreen: View {
  @State private var locations: [CLLocationCoordinate2D] = []
  @State private var isTracking: Bool = false

    var body: some View {
      MapLocationView(locations: $locations, isTracking: $isTracking)
        .frame(width: 400, height: 500)
    }
}

#Preview {
    LiveRouteScreen()
}
