//
//  WorkoutFiltersView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.08.2023.
//

import SwiftUI

struct WorkoutFiltersView: View {
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(onBack: nil, onContinue: nil)
            
            
            Spacer()
        }
        .padding([.top])
    }
}

struct WorkoutFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFiltersView()
    }
}
