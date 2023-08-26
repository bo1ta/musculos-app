//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import SwiftUI
import Charts

struct DashboardView: View {
    var body: some View {
        VStack {
            CustomNavigationBarView(title: "Your weight", rightBarButton: IconButtonView(systemImage: "greaterthan"), onBack: nil, onContinue: {
            })
            HStack(spacing: 1) {
                ProgressCardView(cardItem: ProgressCardItem(value: "64 kg", description: "Initial weight"))
                ProgressCardView(cardItem: ProgressCardItem(value: "59 kg", description: "Current weight"))
                ProgressCardView(cardItem: ProgressCardItem(value: "64 kg", description: "Initial weight"))
            }
            Spacer()
        }
        .padding(.top, 2)
        .padding([.leading, .trailing], 3)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
