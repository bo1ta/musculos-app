//
//  MeDataView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct MeDataView: View {
  let userProfile: UserProfileProvider?
  
  var body: some View {
    VStack {
      Circle()
        .frame(width: 80, height: 80)
        .foregroundStyle(.red)
        .shadow(radius: 1.2)
      
      VStack(alignment: .center, spacing: 2) {
        if let fullName = userProfile?.fullName, let username = userProfile?.username {
          Text(fullName)
            .font(.custom(AppFont.medium, size: 16))
            .foregroundStyle(.white)
          Text("@\(username)")
            .font(.custom(AppFont.regular, size: 10))
            .foregroundStyle(.white)
        }
      }
    }
  }
}

#Preview {
  MeDataView(userProfile: UserProfileFactory.build(isCurrentUser: true))
}
