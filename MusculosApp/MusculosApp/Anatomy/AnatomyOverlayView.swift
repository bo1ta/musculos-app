//
//  AnatomyOverlayView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.09.2023.
//

import SwiftUI
import CoreData

struct AnatomyOverlayView: View {
    var muscles: [Muscle]
    var customSize: CGFloat
    
    init(muscles: [Muscle], customSize: CGFloat = 150) {
        self.muscles = muscles
        self.customSize = customSize
    }
    
    var body: some View {
        ZStack {
            Image("muscular_system_front")
                .resizable()
            
            ForEach(muscles) { muscle in
                muscle.primaryImage
                    .resizable()
            }
        }
        .frame(maxWidth: customSize, maxHeight: customSize * 2)
    }
}

struct AnatomyOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AnatomyOverlayView(muscles: [])
    }
}
