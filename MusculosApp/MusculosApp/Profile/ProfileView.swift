//
//  ProfileView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.02.2024.
//

import SwiftUI

struct ProfileView: View {
  @EnvironmentObject private var userStore: UserStore
  @Environment(\.mainWindowSize) var mainWindowSize: CGSize
  
  private var userProfile: UserProfileProvider? {
    userStore.currentUserProfile ?? UserProfileFactory.build(isCurrentUser: true)
  }
  
  var body: some View {
    ScrollView {
      VStack {
        BlueBackgroundCard()
          .overlay {
            VStack {
              MeDataView(userProfile: userProfile)
                .padding(.top, 10)
            }
          }
        StatsCard(
          weight: userProfile?.weight?.intValue ?? 0,
          height: userProfile?.height?.intValue ?? 0,
          growth: 100
        )
        .padding(.top, -50)
        
        FavoriteSection()
          .padding([.top, .bottom], 30)
        MuscleChartSection()
        
        WhiteBackgroundCard()
        Spacer()
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ProfileView().environmentObject(UserStore())
}
