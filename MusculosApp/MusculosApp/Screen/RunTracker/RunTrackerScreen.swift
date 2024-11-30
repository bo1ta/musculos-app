//
//  RunTrackerScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.11.2024.
//

import SwiftUI
import MapKit

struct RunTrackerScreen: View {
  @State private var viewModel = RunTrackerViewModel()

  var body: some View {
    VStack {
      MapReader { mapProxy in
        Map {
          if let currentLocationMapItem = viewModel.currentLocationMapItem {
            Marker(item: currentLocationMapItem)
          }

          MapPolyline(coordinates: viewModel.userCustomCoordinates)
            .stroke(.blue, lineWidth: 2.0)

        }
        .onTapGesture(perform: { screenCoord in
          guard let pinLocation = mapProxy.convert(screenCoord, from: .local) else { return }
          viewModel.addMapItem(pinLocation)
        })
        .frame(height: 500)
      }

      Spacer()
    }
    .onAppear {
      viewModel.initialLoad()
    }
  }
}

#Preview {
  RunTrackerScreen()
}
