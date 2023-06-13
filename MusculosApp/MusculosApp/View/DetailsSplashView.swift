//
//  DetailsSplashView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.06.2023.
//

import SwiftUI

struct DetailsSplashView: View {
    var body: some View {
        ZStack {
            Image("deadlift-background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, content: {
                CustomNavigationBar(onBack: {}, onContinue: {})
                    .padding([.leading, .trailing], 20)
                SelectPill(question: "Set your goal", options: ["Lose weight", "Build muscle", "Get toned", "Plan nutrition"])
                ProgressBar(progressCount: 5, currentProgress: 0)
                    .padding([.leading, .trailing], 20)
            })
        }
    }
}

struct DetailsSplashView_Preview: PreviewProvider {
    static var previews: some View {
        DetailsSplashView()
    }
}
