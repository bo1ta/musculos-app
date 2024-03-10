//
//  BlueBackgroundCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI

struct BlueBackgroundCard: View {
    var body: some View {
      Rectangle()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .foregroundStyle(Color.AppColor.blue500)
        .shadow(radius: 1)
    }
}

#Preview {
    BlueBackgroundCard()
}
