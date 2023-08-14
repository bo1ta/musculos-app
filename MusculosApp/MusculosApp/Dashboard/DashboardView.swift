//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            CustomNavigationBarView(title: "Your weight", rightBarButton: IconButtonView(systemImage: "greaterthan"), onBack: nil, onContinue: {
                
            })
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
