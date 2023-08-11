//
//  HearTipView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import SwiftUI

struct HearTipView: View {
    private let title: String
    private let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        TransparentContainerView {
            Text(self.title)
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 20)
            
            Text(self.text)
                .font(.footnote)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 10)
        }
    }
}

struct HearTipView_Preview: PreviewProvider {
    static var previews: some View {
        HearTipView(title: "Transform your body and mind", text: "With the ultimate weight and activity tracking app for anyone who wants to take control of their health and fitness")
    }
}
