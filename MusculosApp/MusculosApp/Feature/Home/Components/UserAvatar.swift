//
//  UserAvatar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Models
import NetworkClient
import Utility

struct UserAvatar: View {
  let profile: UserProfile?

  var body: some View {
    AsyncCachedImage(url: profile?.avatarUrl) { imagePhase in
      switch imagePhase {
      case .success(let image):
        image
          .resizable()
          .frame(width: 40, height: 40)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
      case .empty, .failure(_):
        Circle()
          .frame(height: 40)
          .foregroundStyle(.green)
      @unknown default:
        EmptyView()
          .onAppear {
            MusculosLogger.logError(
              MusculosError.unknownError,
              message: "Unknown error while fetching avatar",
              category: .networking
            )
          }
      }
    }
  }
}

#Preview {
  UserAvatar(profile: UserProfileFactory.createProfile())
}
