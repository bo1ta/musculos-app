//
//  PermissionsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import SwiftUI

struct PermissionsView: View {
  @EnvironmentObject private var healthKitViewModel: HealthKitViewModel
  
  let onDone: () -> Void
  
  private let permissionsReasons = [
    "Personalized workouts",
    "Personalized notifications and reminders",
    "Auto-suggestions for goals & much more"
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Spacer()
      
      Text("In order to fully experience the app, you need to allow read and write permissions to Apple Health.")
        .font(AppFont.body(.regular, size: 14))
      Text("The data you share is used by this app to provide better experience like:")
        .padding(.bottom)
        .font(AppFont.body(.regular, size: 14))
      
      VStack(alignment: .leading) {
        ForEach(permissionsReasons, id: \.self) { reason in
          BulletPointText(text: reason)
        }
      }
      .font(AppFont.header(.regular, size: 14))
      .padding()
      
      
      Text("Note: All the data you share is private and is not uploaded to any server or shared with any service. This means you will lose the current progress when uninstalling the app." )
        .padding(.top)
        .font(AppFont.body(.regular, size: 14))
      
      Spacer()
    }
    .padding()
    .safeAreaInset(edge: .bottom) {
      HStack {
        Button {
          Task { 
            await healthKitViewModel.requestPermissions()
            onDone()
          }
        } label: {
          Text("Allow")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .shadow(radius: 0.5)
        
        Button {
          onDone()
        } label: {
          Text("Skip")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SecondaryButtonStyle())
        .shadow(radius: 0.5)
      }
      .padding()
    }
  }
}

#Preview {
  PermissionsView(onDone: {})
    .environmentObject(HealthKitViewModel())
}
