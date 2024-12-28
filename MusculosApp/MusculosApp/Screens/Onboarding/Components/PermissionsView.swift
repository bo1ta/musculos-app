//
//  PermissionsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Components
import SwiftUI
import Utility

struct PermissionsView: View {
  @Environment(\.healthKitViewModel) private var healthKitViewModel

  let onDone: () -> Void

  private let permissionsReasons = [
    "Personalized workouts",
    "Personalized notifications and reminders",
    "Auto-suggestions for goals & much more",
  ]

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Heading("Enable Apple Health permissions (optional)")
      VStack(alignment: .leading) {
        Text("In order to fully experience the app, you need to allow read and write permissions to Apple Health.")
          .font(AppFont.poppins(.regular, size: 14))
        Text("The data you share is used by this app to provide better experience like:")
          .padding(.bottom)
          .font(AppFont.poppins(.regular, size: 14))

        ForEach(permissionsReasons, id: \.self) { reason in
          BulletPointText(text: reason, color: .orange)
        }
      }
      .font(AppFont.header(.regular, size: 14))
      .padding()

      Spacer()
      doctorImage
    }
    .padding()
    .safeAreaInset(edge: .bottom) {
      HStack {
        SecondaryButton(title: "Skip", action: onDone)
        PrimaryButton(title: "Allow", action: requestPermissions)
      }
      .padding()
    }
  }

  private func requestPermissions() {
    Task {
      await healthKitViewModel.requestPermissions()
      onDone()
    }
  }

  private var doctorImage: some View {
    VStack {
      Spacer()
      Image("doctor-character")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 250, height: 250)
    }
  }
}

#Preview {
  PermissionsView(onDone: {})
}
